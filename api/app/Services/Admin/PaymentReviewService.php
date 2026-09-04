<?php

namespace App\Services\Admin;

use App\Enums\BillingPeriod;
use App\Enums\BusinessStatus;
use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use App\Enums\SubscriptionActorType;
use App\Enums\SubscriptionEventType;
use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Business;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\SubscriptionEvent;
use App\Models\SubscriptionPayment;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class PaymentReviewService
{
    /** @throws ValidationException */
    public function approve(
        SubscriptionPayment $payment,
        AdminUser $admin,
        ?string $adminNotes,
        ?string $ipAddress,
        ?string $userAgent,
    ): SubscriptionPayment {
        return DB::transaction(function () use ($payment, $admin, $adminNotes, $ipAddress, $userAgent): SubscriptionPayment {
            $lockedPayment = SubscriptionPayment::query()->lockForUpdate()->findOrFail($payment->id);
            $lockedPayment->setRelation(
                'business',
                Business::query()->lockForUpdate()->findOrFail($lockedPayment->business_id),
            );
            $lockedPayment->setRelation(
                'plan',
                Plan::query()->lockForUpdate()->findOrFail($lockedPayment->plan_id),
            );

            $this->ensurePending($lockedPayment);
            $this->ensureApprovable($lockedPayment);

            $startsAt = CarbonImmutable::now();
            $expiresAt = $this->expirationFor($lockedPayment->plan->billing_period, $startsAt);
            $offlineGraceUntil = $expiresAt->addDays(
                (int) config('authentication.paid_subscription.offline_grace_days', 3),
            );

            $replacedSubscriptions = Subscription::query()
                ->where('business_id', $lockedPayment->business_id)
                ->whereIn('status', [
                    SubscriptionStatus::Trialing->value,
                    SubscriptionStatus::Active->value,
                    SubscriptionStatus::Grace->value,
                ])
                ->lockForUpdate()
                ->get();

            foreach ($replacedSubscriptions as $replacedSubscription) {
                $previousValues = $this->subscriptionValues($replacedSubscription);

                $replacedSubscription->update([
                    'status' => SubscriptionStatus::Cancelled,
                    'cancelled_at' => $startsAt,
                    'cancellation_reason' => "Replaced by verified payment {$lockedPayment->id}.",
                ]);

                SubscriptionEvent::query()->create([
                    'subscription_id' => $replacedSubscription->id,
                    'event' => SubscriptionEventType::Cancelled,
                    'actor_type' => SubscriptionActorType::Admin,
                    'actor_id' => $admin->id,
                    'previous_values' => $previousValues,
                    'new_values' => $this->subscriptionValues($replacedSubscription->refresh()),
                    'notes' => "Replaced by verified payment {$lockedPayment->id}.",
                ]);
            }

            $subscription = Subscription::query()->create([
                'business_id' => $lockedPayment->business_id,
                'plan_id' => $lockedPayment->plan_id,
                'source' => $this->sourceFor($lockedPayment->method),
                'status' => SubscriptionStatus::Active,
                'starts_at' => $startsAt,
                'expires_at' => $expiresAt,
                'offline_grace_until' => $offlineGraceUntil,
                'auto_renew' => false,
                'activated_by_admin_id' => $admin->id,
            ]);

            SubscriptionEvent::query()->create([
                'subscription_id' => $subscription->id,
                'event' => SubscriptionEventType::Activated,
                'actor_type' => SubscriptionActorType::Admin,
                'actor_id' => $admin->id,
                'previous_values' => null,
                'new_values' => [
                    ...$this->subscriptionValues($subscription),
                    'payment_id' => $lockedPayment->id,
                ],
                'notes' => 'Activated after manual payment verification.',
            ]);

            $previousPaymentValues = $this->paymentValues($lockedPayment);
            $lockedPayment->update([
                'subscription_id' => $subscription->id,
                'status' => PaymentStatus::Verified,
                'verified_by_admin_id' => $admin->id,
                'paid_at' => $lockedPayment->paid_at
                    ?? $lockedPayment->submitted_at
                    ?? $lockedPayment->created_at,
                'verified_at' => $startsAt,
                'rejected_at' => null,
                'rejection_reason' => null,
                'admin_notes' => $this->nullableTrim($adminNotes),
            ]);

            $this->audit(
                payment: $lockedPayment,
                admin: $admin,
                action: 'payment.verified',
                previousValues: $previousPaymentValues,
                newValues: $this->paymentValues($lockedPayment->refresh()),
                ipAddress: $ipAddress,
                userAgent: $userAgent,
            );

            return $lockedPayment->load(['business', 'plan', 'subscription', 'verifiedBy']);
        });
    }

    /** @throws ValidationException */
    public function reject(
        SubscriptionPayment $payment,
        AdminUser $admin,
        string $reason,
        ?string $adminNotes,
        ?string $ipAddress,
        ?string $userAgent,
    ): SubscriptionPayment {
        return DB::transaction(function () use ($payment, $admin, $reason, $adminNotes, $ipAddress, $userAgent): SubscriptionPayment {
            $lockedPayment = SubscriptionPayment::query()->lockForUpdate()->findOrFail($payment->id);
            $this->ensurePending($lockedPayment);

            $previousValues = $this->paymentValues($lockedPayment);
            $lockedPayment->update([
                'status' => PaymentStatus::Rejected,
                'verified_by_admin_id' => $admin->id,
                'verified_at' => null,
                'rejected_at' => now(),
                'rejection_reason' => trim($reason),
                'admin_notes' => $this->nullableTrim($adminNotes),
            ]);

            $this->audit(
                payment: $lockedPayment,
                admin: $admin,
                action: 'payment.rejected',
                previousValues: $previousValues,
                newValues: $this->paymentValues($lockedPayment->refresh()),
                ipAddress: $ipAddress,
                userAgent: $userAgent,
            );

            return $lockedPayment->load(['business', 'plan', 'verifiedBy']);
        });
    }

    /** @throws ValidationException */
    private function ensurePending(SubscriptionPayment $payment): void
    {
        if ($payment->status !== PaymentStatus::Pending) {
            throw ValidationException::withMessages([
                'payment' => 'This payment has already been reviewed and cannot be changed.',
            ]);
        }
    }

    /** @throws ValidationException */
    private function ensureApprovable(SubscriptionPayment $payment): void
    {
        if (! in_array($payment->method, [PaymentMethod::BankTransfer, PaymentMethod::Cash], true)) {
            throw ValidationException::withMessages([
                'payment' => 'Only bank-transfer and cash payments can be verified manually.',
            ]);
        }

        if ($payment->method === PaymentMethod::BankTransfer && blank($payment->transaction_reference)) {
            throw ValidationException::withMessages([
                'payment' => 'A bank transaction reference is required before this payment can be verified.',
            ]);
        }

        if ($payment->business->status !== BusinessStatus::Active) {
            throw ValidationException::withMessages([
                'payment' => 'Reactivate this business before approving its payment.',
            ]);
        }

        if (! $payment->plan->is_active) {
            throw ValidationException::withMessages([
                'payment' => 'The selected plan is inactive and cannot be assigned.',
            ]);
        }

        if ((float) $payment->plan->price <= 0) {
            throw ValidationException::withMessages([
                'payment' => 'The selected plan is not a payable subscription plan.',
            ]);
        }

        if ($payment->currency_code !== $payment->plan->currency_code) {
            throw ValidationException::withMessages([
                'payment' => 'The payment currency does not match the selected plan.',
            ]);
        }

        if ($payment->amount !== $payment->plan->price) {
            throw ValidationException::withMessages([
                'payment' => 'The payment amount does not match the selected plan price.',
            ]);
        }

        if ($payment->plan->billing_period === BillingPeriod::Custom) {
            throw ValidationException::withMessages([
                'payment' => 'This plan has no supported paid billing period. Choose a monthly, quarterly or yearly plan.',
            ]);
        }
    }

    /** @throws ValidationException */
    private function expirationFor(BillingPeriod $period, CarbonImmutable $startsAt): CarbonImmutable
    {
        return match ($period) {
            BillingPeriod::Monthly => $startsAt->addMonthNoOverflow(),
            BillingPeriod::Quarterly => $startsAt->addMonthsNoOverflow(3),
            BillingPeriod::Yearly => $startsAt->addYearNoOverflow(),
            BillingPeriod::Custom => throw ValidationException::withMessages([
                'payment' => 'This plan has no supported paid billing period.',
            ]),
        };
    }

    private function sourceFor(PaymentMethod $method): SubscriptionSource
    {
        return match ($method) {
            PaymentMethod::BankTransfer => SubscriptionSource::BankTransfer,
            PaymentMethod::Cash => SubscriptionSource::Cash,
            default => throw ValidationException::withMessages([
                'payment' => 'This payment method cannot be activated manually.',
            ]),
        };
    }

    /** @return array<string, mixed> */
    private function subscriptionValues(Subscription $subscription): array
    {
        return [
            'status' => $subscription->status->value,
            'plan_id' => $subscription->plan_id,
            'source' => $subscription->source->value,
            'starts_at' => $subscription->starts_at->toIso8601String(),
            'expires_at' => $subscription->expires_at->toIso8601String(),
            'offline_grace_until' => $subscription->offline_grace_until?->toIso8601String(),
            'cancelled_at' => $subscription->cancelled_at?->toIso8601String(),
            'cancellation_reason' => $subscription->cancellation_reason,
        ];
    }

    /** @return array<string, mixed> */
    private function paymentValues(SubscriptionPayment $payment): array
    {
        return [
            'status' => $payment->status->value,
            'subscription_id' => $payment->subscription_id,
            'verified_by_admin_id' => $payment->verified_by_admin_id,
            'verified_at' => $payment->verified_at?->toIso8601String(),
            'rejected_at' => $payment->rejected_at?->toIso8601String(),
            'rejection_reason' => $payment->rejection_reason,
            'admin_notes' => $payment->admin_notes,
        ];
    }

    /**
     * @param  array<string, mixed>  $previousValues
     * @param  array<string, mixed>  $newValues
     */
    private function audit(
        SubscriptionPayment $payment,
        AdminUser $admin,
        string $action,
        array $previousValues,
        array $newValues,
        ?string $ipAddress,
        ?string $userAgent,
    ): void {
        AdminAuditLog::query()->create([
            'admin_user_id' => $admin->id,
            'business_id' => $payment->business_id,
            'action' => $action,
            'subject_type' => SubscriptionPayment::class,
            'subject_id' => $payment->id,
            'previous_values' => $previousValues,
            'new_values' => $newValues,
            'ip_address' => $ipAddress,
            'user_agent' => $userAgent,
        ]);
    }

    private function nullableTrim(?string $value): ?string
    {
        $trimmed = trim((string) $value);

        return $trimmed === '' ? null : $trimmed;
    }
}
