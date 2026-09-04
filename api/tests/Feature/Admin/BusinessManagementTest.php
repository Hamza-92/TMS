<?php

namespace Tests\Feature\Admin;

use App\Enums\BusinessStatus;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BusinessManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_cannot_access_business_management(): void
    {
        $business = $this->createBusiness();

        $this->get('/admin/businesses')->assertRedirect('/admin/login');
        $this->get("/admin/businesses/{$business->id}")->assertRedirect('/admin/login');
    }

    public function test_admin_can_search_and_filter_businesses(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $matching = $this->createBusiness([
            'name' => 'Ayesha Tailors',
            'phone_e164' => '+923001111111',
        ]);
        $this->createBusiness([
            'name' => 'City Stitch',
            'phone_e164' => '+923002222222',
            'status' => BusinessStatus::Suspended->value,
            'suspended_at' => now(),
            'suspension_reason' => 'Account review is currently required.',
        ]);

        $this->actingAs($admin, 'admin')
            ->get('/admin/businesses?q=Ayesha&status=active')
            ->assertOk()
            ->assertViewIs('admin.businesses.index')
            ->assertSee('Ayesha Tailors')
            ->assertDontSee('City Stitch')
            ->assertSee(route('admin.businesses.show', $matching));
    }

    public function test_admin_can_filter_by_latest_subscription_status(): void
    {
        $admin = $this->createAdmin(['role' => 'finance']);
        $trialBusiness = $this->createBusiness(['name' => 'Trial Tailors']);
        $unsubscribedBusiness = $this->createBusiness(['name' => 'No Plan Tailors']);
        $plan = $this->createPlan();

        Subscription::query()->create([
            'business_id' => $trialBusiness->id,
            'plan_id' => $plan->id,
            'source' => 'trial',
            'status' => 'trialing',
            'starts_at' => now(),
            'expires_at' => now()->addDays(14),
        ]);

        $this->actingAs($admin, 'admin')
            ->get('/admin/businesses?subscription=trialing')
            ->assertOk()
            ->assertSee('Trial Tailors')
            ->assertDontSee('No Plan Tailors');

        $this->get('/admin/businesses?subscription=none')
            ->assertOk()
            ->assertSee($unsubscribedBusiness->name)
            ->assertDontSee($trialBusiness->name);
    }

    public function test_admin_can_view_complete_business_details(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $business = $this->createBusiness(['name' => 'Needle House']);

        $this->actingAs($admin, 'admin')
            ->get(route('admin.businesses.show', $business))
            ->assertOk()
            ->assertViewIs('admin.businesses.show')
            ->assertSee('Needle House')
            ->assertSee('Members')
            ->assertSee('Subscription history')
            ->assertSee('Recent payments')
            ->assertDontSee('Suspend business');
    }

    public function test_superadmin_can_suspend_an_active_business_and_action_is_audited(): void
    {
        $admin = $this->createAdmin();
        $business = $this->createBusiness(['name' => 'Needle House']);
        $reason = 'Payment ownership needs manual verification.';

        $this->actingAs($admin, 'admin')
            ->post(route('admin.businesses.suspend', $business), ['reason' => $reason])
            ->assertRedirect(route('admin.businesses.show', $business))
            ->assertSessionHas('status');

        $business->refresh();
        $this->assertSame(BusinessStatus::Suspended->value, $business->status->value);
        $this->assertSame($reason, $business->suspension_reason);
        $this->assertNotNull($business->suspended_at);

        $audit = AdminAuditLog::query()->where('action', 'business.suspended')->sole();
        $this->assertSame($admin->id, $audit->admin_user_id);
        $this->assertSame($business->id, $audit->business_id);
        $this->assertSame(BusinessStatus::Active->value, $audit->previous_values['status']);
        $this->assertSame(BusinessStatus::Suspended->value, $audit->new_values['status']);
        $this->assertSame($reason, $audit->new_values['suspension_reason']);
    }

    public function test_suspension_requires_a_clear_reason(): void
    {
        $admin = $this->createAdmin();
        $business = $this->createBusiness();

        $this->actingAs($admin, 'admin')
            ->from(route('admin.businesses.show', $business))
            ->post(route('admin.businesses.suspend', $business), ['reason' => 'short'])
            ->assertRedirect(route('admin.businesses.show', $business))
            ->assertSessionHasErrors([
                'reason' => 'The suspension reason must be at least 10 characters.',
            ]);

        $this->assertSame(BusinessStatus::Active, $business->fresh()->status);
        $this->assertDatabaseMissing('admin_audit_logs', ['action' => 'business.suspended']);
    }

    public function test_support_admin_cannot_change_business_access(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);
        $business = $this->createBusiness();

        $this->actingAs($admin, 'admin')
            ->post(route('admin.businesses.suspend', $business), [
                'reason' => 'This attempt must be rejected by authorization.',
            ])
            ->assertForbidden();

        $this->assertSame(BusinessStatus::Active, $business->fresh()->status);
    }

    public function test_superadmin_can_reactivate_a_suspended_business_and_action_is_audited(): void
    {
        $admin = $this->createAdmin();
        $business = $this->createBusiness([
            'status' => BusinessStatus::Suspended->value,
            'suspended_at' => now()->subHour(),
            'suspension_reason' => 'Payment ownership needs manual verification.',
        ]);

        $this->actingAs($admin, 'admin')
            ->post(route('admin.businesses.reactivate', $business))
            ->assertRedirect(route('admin.businesses.show', $business))
            ->assertSessionHas('status');

        $business->refresh();
        $this->assertSame(BusinessStatus::Active, $business->status);
        $this->assertNull($business->suspended_at);
        $this->assertNull($business->suspension_reason);

        $audit = AdminAuditLog::query()->where('action', 'business.reactivated')->sole();
        $this->assertSame(BusinessStatus::Suspended->value, $audit->previous_values['status']);
        $this->assertSame(BusinessStatus::Active->value, $audit->new_values['status']);
    }

    public function test_invalid_status_transition_is_rejected_without_an_audit_record(): void
    {
        $admin = $this->createAdmin();
        $business = $this->createBusiness();

        $this->actingAs($admin, 'admin')
            ->from(route('admin.businesses.show', $business))
            ->post(route('admin.businesses.reactivate', $business))
            ->assertRedirect(route('admin.businesses.show', $business))
            ->assertSessionHasErrors('business');

        $this->assertDatabaseMissing('admin_audit_logs', ['action' => 'business.reactivated']);
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
    private function createBusiness(array $overrides = []): Business
    {
        $owner = User::factory()->create();
        $business = Business::query()->create(array_merge([
            'name' => fake()->unique()->company(),
            'slug' => fake()->unique()->slug(),
            'phone_e164' => fake()->unique()->e164PhoneNumber(),
            'created_by_user_id' => $owner->id,
            'status' => BusinessStatus::Active->value,
        ], $overrides));

        BusinessMember::query()->create([
            'business_id' => $business->id,
            'user_id' => $owner->id,
            'role' => 'owner',
            'status' => 'active',
            'joined_at' => now(),
        ]);

        return $business;
    }

    private function createPlan(): Plan
    {
        return Plan::query()->create([
            'code' => fake()->unique()->lexify('plan-????'),
            'name' => 'Demo',
            'billing_period' => 'custom',
            'price' => 0,
            'currency_code' => 'PKR',
            'trial_days' => 14,
            'is_active' => true,
        ]);
    }
}
