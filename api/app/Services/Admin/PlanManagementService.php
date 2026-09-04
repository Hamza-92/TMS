<?php

namespace App\Services\Admin;

use App\Enums\PaymentStatus;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Plan;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class PlanManagementService
{
    /** @param array<string, mixed> $data */
    public function create(
        array $data,
        AdminUser $admin,
        ?string $ipAddress,
        ?string $userAgent,
    ): Plan {
        return DB::transaction(function () use ($data, $admin, $ipAddress, $userAgent): Plan {
            $plan = Plan::query()->create([
                ...$this->planValues($data),
                'code' => $this->uniqueCode((string) $data['name']),
                'trial_days' => 0,
                'currency_code' => 'PKR',
                'sort_order' => (int) Plan::query()->max('sort_order') + 1,
            ]);

            $this->audit($plan, $admin, 'plan.created', [], $this->auditValues($plan), $ipAddress, $userAgent);

            return $plan;
        });
    }

    /**
     * @param  array<string, mixed>  $data
     *
     * @throws ValidationException
     */
    public function update(
        Plan $plan,
        array $data,
        AdminUser $admin,
        ?string $ipAddress,
        ?string $userAgent,
    ): Plan {
        return DB::transaction(function () use ($plan, $data, $admin, $ipAddress, $userAgent): Plan {
            $lockedPlan = Plan::query()->lockForUpdate()->findOrFail($plan->id);

            if ($lockedPlan->code === config('authentication.trial.plan_code')) {
                throw ValidationException::withMessages([
                    'plan' => 'The automatic demo plan is system-managed and cannot be edited here.',
                ]);
            }

            $newValues = $this->planValues($data);
            $billingChanged = $lockedPlan->billing_period->value !== $newValues['billing_period']
                || $lockedPlan->price !== $newValues['price']
                || $lockedPlan->currency_code !== 'PKR';

            if ($billingChanged && ($lockedPlan->subscriptions()->exists() || $lockedPlan->payments()->exists())) {
                throw ValidationException::withMessages([
                    'plan' => 'Billing cannot be changed after a plan has been used. Create a new plan for the new price or billing period.',
                ]);
            }

            $previousValues = $this->auditValues($lockedPlan);
            $lockedPlan->update($newValues);

            if ($previousValues !== $this->auditValues($lockedPlan->refresh())) {
                $this->audit(
                    $lockedPlan,
                    $admin,
                    'plan.updated',
                    $previousValues,
                    $this->auditValues($lockedPlan),
                    $ipAddress,
                    $userAgent,
                );
            }

            return $lockedPlan;
        });
    }

    /** @throws ValidationException */
    public function toggleActive(
        Plan $plan,
        AdminUser $admin,
        ?string $ipAddress,
        ?string $userAgent,
    ): Plan {
        return DB::transaction(function () use ($plan, $admin, $ipAddress, $userAgent): Plan {
            $lockedPlan = Plan::query()->lockForUpdate()->findOrFail($plan->id);

            if ($lockedPlan->is_active && $lockedPlan->code === config('authentication.trial.plan_code')) {
                throw ValidationException::withMessages([
                    'plan' => 'The demo plan must remain active so new customer registrations can start their trial.',
                ]);
            }

            if ($lockedPlan->is_active && $lockedPlan->payments()
                ->where('status', PaymentStatus::Pending->value)
                ->exists()) {
                throw ValidationException::withMessages([
                    'plan' => 'Resolve this plan’s pending payment requests before making it unavailable.',
                ]);
            }

            $previousValues = $this->auditValues($lockedPlan);
            $lockedPlan->update(['is_active' => ! $lockedPlan->is_active]);

            $this->audit(
                $lockedPlan,
                $admin,
                $lockedPlan->is_active ? 'plan.activated' : 'plan.deactivated',
                $previousValues,
                $this->auditValues($lockedPlan->refresh()),
                $ipAddress,
                $userAgent,
            );

            return $lockedPlan;
        });
    }

    /** @param array<string, mixed> $data
     * @return array<string, mixed>
     */
    private function planValues(array $data): array
    {
        return [
            'name' => trim((string) $data['name']),
            'description' => $this->nullableTrim(Arr::get($data, 'description')),
            'billing_period' => (string) $data['billing_period'],
            'price' => number_format((float) $data['price'], 2, '.', ''),
            'currency_code' => 'PKR',
            'features' => [
                'cloud_backup' => (bool) Arr::get($data, 'features.cloud_backup', false),
                'reports' => (bool) Arr::get($data, 'features.reports', false),
                'staff_accounts' => (bool) Arr::get($data, 'features.staff_accounts', false),
            ],
            'limits' => [
                'staff' => (int) Arr::get($data, 'limits.staff'),
                'devices' => (int) Arr::get($data, 'limits.devices'),
                'customers' => (int) Arr::get($data, 'limits.customers'),
            ],
            'is_active' => (bool) Arr::get($data, 'is_active', false),
        ];
    }

    private function uniqueCode(string $name): string
    {
        $base = Str::limit(Str::slug($name), 42, '');
        $base = $base !== '' ? $base : 'plan';
        $code = $base;
        $suffix = 2;

        while (Plan::query()->where('code', $code)->exists()) {
            $suffixText = '-'.$suffix++;
            $code = Str::limit($base, 50 - strlen($suffixText), '').$suffixText;
        }

        return $code;
    }

    /** @return array<string, mixed> */
    private function auditValues(Plan $plan): array
    {
        return [
            'code' => $plan->code,
            'name' => $plan->name,
            'description' => $plan->description,
            'billing_period' => $plan->billing_period->value,
            'price' => $plan->price,
            'currency_code' => $plan->currency_code,
            'features' => $plan->features,
            'limits' => $plan->limits,
            'is_active' => $plan->is_active,
        ];
    }

    /**
     * @param  array<string, mixed>  $previousValues
     * @param  array<string, mixed>  $newValues
     */
    private function audit(
        Plan $plan,
        AdminUser $admin,
        string $action,
        array $previousValues,
        array $newValues,
        ?string $ipAddress,
        ?string $userAgent,
    ): void {
        AdminAuditLog::query()->create([
            'admin_user_id' => $admin->id,
            'business_id' => null,
            'action' => $action,
            'subject_type' => Plan::class,
            'subject_id' => $plan->id,
            'previous_values' => $previousValues,
            'new_values' => $newValues,
            'ip_address' => $ipAddress,
            'user_agent' => $userAgent,
        ]);
    }

    private function nullableTrim(mixed $value): ?string
    {
        $trimmed = trim((string) $value);

        return $trimmed === '' ? null : $trimmed;
    }
}
