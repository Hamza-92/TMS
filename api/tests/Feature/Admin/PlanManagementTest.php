<?php

namespace Tests\Feature\Admin;

use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Business;
use App\Models\Plan;
use App\Models\SubscriptionPayment;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PlanManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_cannot_access_plan_management(): void
    {
        $this->get('/admin/plans')->assertRedirect('/admin/login');
    }

    public function test_support_admin_can_inspect_plans_but_cannot_manage_them(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $plan = $this->createPlan();

        $this->actingAs($admin, 'admin')
            ->get(route('admin.plans.index', ['edit' => $plan->id]))
            ->assertOk()
            ->assertSee($plan->name)
            ->assertSee('Plan details')
            ->assertDontSee('Add paid plan');

        $this->post(route('admin.plans.store'), $this->validPlanData())->assertForbidden();
        $this->put(route('admin.plans.update', $plan), $this->validPlanData())->assertForbidden();
        $this->post(route('admin.plans.toggle', $plan))->assertForbidden();
    }

    public function test_superadmin_can_create_complete_paid_plan_from_one_form(): void
    {
        $admin = $this->createAdmin();

        $this->actingAs($admin, 'admin')
            ->get(route('admin.plans.index', ['create' => 1]))
            ->assertOk()
            ->assertSee('Complete the full paid-plan setup below.')
            ->assertSee('Create plan');

        $this
            ->post(route('admin.plans.store'), $this->validPlanData())
            ->assertRedirect()
            ->assertSessionHas('status');

        $plan = Plan::query()->where('code', 'professional-monthly')->sole();
        $this->assertSame('Professional Monthly', $plan->name);
        $this->assertSame('monthly', $plan->billing_period->value);
        $this->assertSame('1500.00', $plan->price);
        $this->assertSame('PKR', $plan->currency_code);
        $this->assertSame(0, $plan->trial_days);
        $this->assertTrue($plan->is_active);
        $this->assertSame([
            'cloud_backup' => true,
            'reports' => true,
            'staff_accounts' => true,
        ], $plan->features);
        $this->assertSame(['staff' => 5, 'devices' => 3, 'customers' => 1000], $plan->limits);

        $audit = AdminAuditLog::query()->where('action', 'plan.created')->sole();
        $this->assertSame($admin->id, $audit->admin_user_id);
        $this->assertSame($plan->id, $audit->subject_id);
        $this->assertNull($audit->business_id);
        $this->assertSame('professional-monthly', $audit->new_values['code']);
    }

    public function test_generated_plan_codes_remain_unique_without_extra_admin_input(): void
    {
        $admin = $this->createAdmin();

        $this->actingAs($admin, 'admin')->post(route('admin.plans.store'), $this->validPlanData());
        $this->post(route('admin.plans.store'), $this->validPlanData());

        $this->assertDatabaseHas('plans', ['code' => 'professional-monthly']);
        $this->assertDatabaseHas('plans', ['code' => 'professional-monthly-2']);
    }

    public function test_plan_form_returns_clear_validation_errors(): void
    {
        $admin = $this->createAdmin();

        $this->actingAs($admin, 'admin')
            ->from(route('admin.plans.index', ['create' => 1]))
            ->post(route('admin.plans.store'), [
                'name' => '',
                'billing_period' => 'custom',
                'price' => 0,
                'limits' => [],
            ])
            ->assertRedirect(route('admin.plans.index', ['create' => 1]))
            ->assertSessionHasErrors([
                'name',
                'billing_period',
                'price' => 'Enter a paid-plan price of at least PKR 1.',
                'limits.staff' => 'Enter the number of staff accounts included.',
                'limits.devices' => 'Enter the number of devices included.',
                'limits.customers' => 'Enter the customer limit included.',
            ]);

        $this->assertSame(0, Plan::query()->count());
    }

    public function test_superadmin_can_update_unused_plan_and_change_availability(): void
    {
        $admin = $this->createAdmin();
        $plan = $this->createPlan();
        $updatedData = $this->validPlanData([
            'name' => 'Professional Quarterly',
            'billing_period' => 'quarterly',
            'price' => 4000,
            'is_active' => null,
        ]);
        unset($updatedData['is_active']);

        $this->actingAs($admin, 'admin')
            ->put(route('admin.plans.update', $plan), $updatedData)
            ->assertRedirect(route('admin.plans.index', ['edit' => $plan->id]))
            ->assertSessionHas('status');

        $plan->refresh();
        $this->assertSame('Professional Quarterly', $plan->name);
        $this->assertSame('quarterly', $plan->billing_period->value);
        $this->assertSame('4000.00', $plan->price);
        $this->assertFalse($plan->is_active);
        $this->assertDatabaseHas('admin_audit_logs', [
            'action' => 'plan.updated',
            'subject_id' => $plan->id,
        ]);

        $this->post(route('admin.plans.toggle', $plan))
            ->assertSessionHas('status');

        $this->assertTrue($plan->fresh()->is_active);
        $this->assertDatabaseHas('admin_audit_logs', [
            'action' => 'plan.activated',
            'subject_id' => $plan->id,
        ]);
    }

    public function test_billing_is_immutable_after_plan_has_payment_history(): void
    {
        $admin = $this->createAdmin();
        $plan = $this->createPlan();
        $this->createPayment($plan, ['status' => 'verified']);

        $this->actingAs($admin, 'admin')
            ->from(route('admin.plans.index', ['edit' => $plan->id]))
            ->put(route('admin.plans.update', $plan), $this->validPlanData([
                'billing_period' => 'yearly',
                'price' => 15000,
            ]))
            ->assertRedirect(route('admin.plans.index', ['edit' => $plan->id]))
            ->assertSessionHasErrors([
                'plan' => 'Billing cannot be changed after a plan has been used. Create a new plan for the new price or billing period.',
            ]);

        $plan->refresh();
        $this->assertSame('monthly', $plan->billing_period->value);
        $this->assertSame('1500.00', $plan->price);
        $this->assertDatabaseMissing('admin_audit_logs', ['action' => 'plan.updated']);
    }

    public function test_plan_with_pending_payments_cannot_be_made_unavailable(): void
    {
        $admin = $this->createAdmin();
        $plan = $this->createPlan();
        $this->createPayment($plan);

        $this->actingAs($admin, 'admin')
            ->from(route('admin.plans.index', ['edit' => $plan->id]))
            ->post(route('admin.plans.toggle', $plan))
            ->assertRedirect(route('admin.plans.index', ['edit' => $plan->id]))
            ->assertSessionHasErrors([
                'plan' => 'Resolve this plan’s pending payment requests before making it unavailable.',
            ]);

        $this->assertTrue($plan->fresh()->is_active);
    }

    public function test_demo_plan_cannot_be_edited_or_deactivated(): void
    {
        $admin = $this->createAdmin();
        $plan = $this->createPlan([
            'code' => 'demo',
            'name' => 'Demo',
            'billing_period' => 'custom',
            'price' => 0,
            'trial_days' => 14,
        ]);

        $this->actingAs($admin, 'admin')
            ->from(route('admin.plans.index', ['edit' => $plan->id]))
            ->put(route('admin.plans.update', $plan), $this->validPlanData())
            ->assertSessionHasErrors('plan');

        $this->post(route('admin.plans.toggle', $plan))
            ->assertSessionHasErrors([
                'plan' => 'The demo plan must remain active so new customer registrations can start their trial.',
            ]);

        $this->assertTrue($plan->fresh()->is_active);
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

    /** @param array<string, mixed> $overrides */
    private function createPlan(array $overrides = []): Plan
    {
        return Plan::query()->create(array_merge([
            'code' => fake()->unique()->lexify('plan-????'),
            'name' => 'Professional Monthly',
            'description' => 'For growing tailor businesses.',
            'billing_period' => 'monthly',
            'price' => 1500,
            'currency_code' => 'PKR',
            'trial_days' => 0,
            'features' => ['cloud_backup' => true, 'reports' => true, 'staff_accounts' => true],
            'limits' => ['staff' => 5, 'devices' => 3, 'customers' => 1000],
            'is_active' => true,
        ], $overrides));
    }

    /** @param array<string, mixed> $overrides
     * @return array<string, mixed>
     */
    private function validPlanData(array $overrides = []): array
    {
        return array_replace_recursive([
            'name' => 'Professional Monthly',
            'description' => 'For growing tailor businesses.',
            'billing_period' => 'monthly',
            'price' => 1500,
            'is_active' => 1,
            'features' => [
                'cloud_backup' => 1,
                'reports' => 1,
                'staff_accounts' => 1,
            ],
            'limits' => [
                'staff' => 5,
                'devices' => 3,
                'customers' => 1000,
            ],
        ], $overrides);
    }

    /** @param array<string, mixed> $overrides */
    private function createPayment(Plan $plan, array $overrides = []): SubscriptionPayment
    {
        $owner = User::factory()->create();
        $business = Business::query()->create([
            'name' => fake()->company(),
            'slug' => fake()->unique()->slug(),
            'phone_e164' => fake()->unique()->e164PhoneNumber(),
            'created_by_user_id' => $owner->id,
            'status' => 'active',
        ]);

        return SubscriptionPayment::query()->create(array_merge([
            'business_id' => $business->id,
            'plan_id' => $plan->id,
            'method' => 'bank_transfer',
            'amount' => $plan->price,
            'currency_code' => $plan->currency_code,
            'transaction_reference' => fake()->unique()->bothify('BANK-####-????'),
            'status' => 'pending',
            'submitted_by_user_id' => $owner->id,
            'submitted_at' => now(),
        ], $overrides));
    }
}
