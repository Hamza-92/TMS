<?php

namespace Tests\Feature\Admin;

use App\Enums\BusinessStatus;
use App\Enums\PaymentStatus;
use App\Enums\SubscriptionStatus;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\SubscriptionEvent;
use App\Models\SubscriptionPayment;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PaymentManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_cannot_access_payment_management(): void
    {
        $payment = $this->createPayment();

        $this->get('/admin/payments')->assertRedirect('/admin/login');
        $this->get("/admin/payments/{$payment->id}")->assertRedirect('/admin/login');
    }

    public function test_admin_can_search_and_filter_payment_requests(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $matching = $this->createPayment([
            'transaction_reference' => 'BANK-AYESHA-1001',
            'method' => 'bank_transfer',
        ], ['name' => 'Ayesha Tailors']);
        $other = $this->createPayment([
            'transaction_reference' => 'CASH-OTHER-1002',
            'method' => 'cash',
            'status' => 'rejected',
        ], ['name' => 'City Stitch']);

        $this->actingAs($admin, 'admin')
            ->get('/admin/payments?q=Ayesha&status=pending&method=bank_transfer')
            ->assertOk()
            ->assertViewIs('admin.payments.index')
            ->assertSee($matching->business->name)
            ->assertDontSee($other->business->name)
            ->assertSee(route('admin.payments.show', $matching));
    }

    public function test_support_admin_can_view_but_cannot_decide_a_payment(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $payment = $this->createPayment();

        $this->actingAs($admin, 'admin')
            ->get(route('admin.payments.show', $payment))
            ->assertOk()
            ->assertDontSee('Verify and activate');

        $this->post(route('admin.payments.approve', $payment))->assertForbidden();
        $this->post(route('admin.payments.reject', $payment), [
            'rejection_reason' => 'The payment cannot be located in the account.',
        ])->assertForbidden();

        $this->assertSame(PaymentStatus::Pending, $payment->fresh()->status);
    }

    public function test_finance_admin_can_verify_payment_and_activate_subscription_atomically(): void
    {
        $now = CarbonImmutable::parse('2026-09-04 10:00:00');
        $this->travelTo($now);

        $admin = $this->createAdmin(['role' => 'finance']);
        $payment = $this->createPayment();
        $trial = Subscription::query()->create([
            'business_id' => $payment->business_id,
            'plan_id' => $payment->plan_id,
            'source' => 'trial',
            'status' => 'trialing',
            'starts_at' => $now->subDays(3),
            'expires_at' => $now->addDays(11),
        ]);

        $this->actingAs($admin, 'admin')
            ->post(route('admin.payments.approve', $payment), [
                'admin_notes' => 'Reference confirmed in the bank statement.',
            ])
            ->assertRedirect(route('admin.payments.show', $payment))
            ->assertSessionHas('status');

        $payment->refresh();
        $trial->refresh();

        $this->assertSame(PaymentStatus::Verified, $payment->status);
        $this->assertSame($admin->id, $payment->verified_by_admin_id);
        $this->assertNotNull($payment->subscription_id);
        $this->assertSame(SubscriptionStatus::Cancelled, $trial->status);

        $subscription = Subscription::query()->findOrFail($payment->subscription_id);
        $this->assertSame(SubscriptionStatus::Active, $subscription->status);
        $this->assertSame('bank_transfer', $subscription->source->value);
        $this->assertTrue($subscription->starts_at->equalTo($now));
        $this->assertTrue($subscription->expires_at->equalTo($now->addMonthNoOverflow()));
        $this->assertTrue($subscription->offline_grace_until->equalTo($now->addMonthNoOverflow()->addDays(3)));

        $this->assertDatabaseHas('subscription_events', [
            'subscription_id' => $trial->id,
            'event' => 'cancelled',
            'actor_id' => $admin->id,
        ]);
        $this->assertDatabaseHas('subscription_events', [
            'subscription_id' => $subscription->id,
            'event' => 'activated',
            'actor_id' => $admin->id,
        ]);

        $audit = AdminAuditLog::query()->where('action', 'payment.verified')->sole();
        $this->assertSame($payment->id, $audit->subject_id);
        $this->assertSame('pending', $audit->previous_values['status']);
        $this->assertSame('verified', $audit->new_values['status']);
        $this->assertSame($subscription->id, $audit->new_values['subscription_id']);
    }

    public function test_finance_admin_can_reject_payment_without_changing_subscription_access(): void
    {
        $admin = $this->createAdmin(['role' => 'finance']);
        $payment = $this->createPayment();
        $reason = 'The supplied bank reference could not be located.';

        $this->actingAs($admin, 'admin')
            ->post(route('admin.payments.reject', $payment), [
                'rejection_reason' => $reason,
                'admin_notes' => 'Checked the statement twice.',
            ])
            ->assertRedirect(route('admin.payments.show', $payment))
            ->assertSessionHas('status');

        $payment->refresh();
        $this->assertSame(PaymentStatus::Rejected, $payment->status);
        $this->assertSame($reason, $payment->rejection_reason);
        $this->assertSame($admin->id, $payment->verified_by_admin_id);
        $this->assertNull($payment->subscription_id);
        $this->assertSame(0, Subscription::query()->count());
        $this->assertDatabaseHas('admin_audit_logs', [
            'action' => 'payment.rejected',
            'subject_id' => $payment->id,
        ]);
    }

    public function test_rejection_requires_a_clear_reason(): void
    {
        $admin = $this->createAdmin(['role' => 'finance']);
        $payment = $this->createPayment();

        $this->actingAs($admin, 'admin')
            ->from(route('admin.payments.show', $payment))
            ->post(route('admin.payments.reject', $payment), ['rejection_reason' => 'Missing'])
            ->assertRedirect(route('admin.payments.show', $payment))
            ->assertSessionHasErrors([
                'rejection_reason' => 'The rejection reason must be at least 10 characters.',
            ]);

        $this->assertSame(PaymentStatus::Pending, $payment->fresh()->status);
        $this->assertSame(0, AdminAuditLog::query()->count());
    }

    public function test_invalid_payment_cannot_activate_a_subscription(): void
    {
        $admin = $this->createAdmin();
        $payment = $this->createPayment(['amount' => 1200]);

        $this->actingAs($admin, 'admin')
            ->from(route('admin.payments.show', $payment))
            ->post(route('admin.payments.approve', $payment))
            ->assertRedirect(route('admin.payments.show', $payment))
            ->assertSessionHasErrors([
                'payment' => 'The payment amount does not match the selected plan price.',
            ]);

        $this->assertSame(PaymentStatus::Pending, $payment->fresh()->status);
        $this->assertSame(0, Subscription::query()->count());
        $this->assertSame(0, SubscriptionEvent::query()->count());
        $this->assertSame(0, AdminAuditLog::query()->count());
    }

    public function test_approval_is_not_replayed_after_payment_has_been_reviewed(): void
    {
        $admin = $this->createAdmin();
        $payment = $this->createPayment();

        $this->actingAs($admin, 'admin')
            ->post(route('admin.payments.approve', $payment))
            ->assertSessionHasNoErrors();

        $this->from(route('admin.payments.show', $payment))
            ->post(route('admin.payments.approve', $payment))
            ->assertRedirect(route('admin.payments.show', $payment))
            ->assertSessionHasErrors([
                'payment' => 'This payment has already been reviewed and cannot be changed.',
            ]);

        $this->assertSame(1, Subscription::query()->count());
        $this->assertSame(1, AdminAuditLog::query()->where('action', 'payment.verified')->count());
    }

    public function test_suspended_business_must_be_reactivated_before_payment_approval(): void
    {
        $admin = $this->createAdmin();
        $payment = $this->createPayment([], [
            'status' => BusinessStatus::Suspended->value,
            'suspended_at' => now(),
            'suspension_reason' => 'Account ownership requires review.',
        ]);

        $this->actingAs($admin, 'admin')
            ->from(route('admin.payments.show', $payment))
            ->post(route('admin.payments.approve', $payment))
            ->assertSessionHasErrors([
                'payment' => 'Reactivate this business before approving its payment.',
            ]);

        $this->assertSame(PaymentStatus::Pending, $payment->fresh()->status);
        $this->assertSame(0, Subscription::query()->count());
    }

    /** @param array<string, mixed> $overrides */
    private function createAdmin(array $overrides = []): AdminUser
    {
        return AdminUser::query()->create(array_merge([
            'name' => 'Platform Owner',
            'email' => fake()->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => 'SecurePass123',
            'role' => 'superadmin',
            'status' => 'active',
        ], $overrides));
    }

    /**
     * @param  array<string, mixed>  $paymentOverrides
     * @param  array<string, mixed>  $businessOverrides
     */
    private function createPayment(array $paymentOverrides = [], array $businessOverrides = []): SubscriptionPayment
    {
        $owner = User::factory()->create();
        $business = Business::query()->create(array_merge([
            'name' => fake()->unique()->company(),
            'slug' => fake()->unique()->slug(),
            'phone_e164' => fake()->unique()->e164PhoneNumber(),
            'created_by_user_id' => $owner->id,
            'status' => BusinessStatus::Active->value,
        ], $businessOverrides));

        BusinessMember::query()->create([
            'business_id' => $business->id,
            'user_id' => $owner->id,
            'role' => 'owner',
            'status' => 'active',
            'joined_at' => now(),
        ]);

        $plan = Plan::query()->create([
            'code' => fake()->unique()->lexify('monthly-????'),
            'name' => 'Professional Monthly',
            'billing_period' => 'monthly',
            'price' => 1500,
            'currency_code' => 'PKR',
            'trial_days' => 0,
            'is_active' => true,
        ]);

        return SubscriptionPayment::query()->create(array_merge([
            'business_id' => $business->id,
            'plan_id' => $plan->id,
            'method' => 'bank_transfer',
            'amount' => 1500,
            'currency_code' => 'PKR',
            'transaction_reference' => fake()->unique()->bothify('BANK-####-????'),
            'status' => 'pending',
            'submitted_by_user_id' => $owner->id,
            'paid_at' => now()->subHour(),
            'submitted_at' => now(),
        ], $paymentOverrides));
    }
}
