<?php

namespace Tests\Feature;

use App\Enums\AdminRole;
use App\Enums\BillingPeriod;
use App\Enums\BusinessRole;
use App\Enums\MembershipStatus;
use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use App\Models\AdminUser;
use App\Models\AuthSession;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Device;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\SubscriptionPayment;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Tests\TestCase;

class FoundationSchemaTest extends TestCase
{
    use RefreshDatabase;

    public function test_foundation_tables_and_security_columns_are_present(): void
    {
        foreach ([
            'users',
            'admin_users',
            'businesses',
            'business_members',
            'business_invitations',
            'devices',
            'auth_sessions',
            'otp_challenges',
            'whatsapp_messages',
            'plans',
            'subscriptions',
            'subscription_payments',
            'subscription_events',
            'trial_claims',
            'admin_audit_logs',
            'account_deletion_requests',
        ] as $table) {
            $this->assertTrue(Schema::hasTable($table), "Expected the {$table} table to exist.");
        }

        $this->assertTrue(Schema::hasColumns('users', [
            'id',
            'phone_e164',
            'phone_verified_at',
            'preferred_locale',
            'status',
            'deleted_at',
        ]));
        $this->assertTrue(Schema::hasColumns('auth_sessions', [
            'device_id',
            'access_token_hash',
            'refresh_token_hash',
            'refresh_expires_at',
            'revoked_at',
        ]));
        $this->assertTrue(Schema::hasColumns('otp_challenges', [
            'code_hash',
            'attempt_count',
            'expires_at',
            'action_token_hash',
        ]));
        $this->assertTrue(Schema::hasColumns('subscription_payments', [
            'method',
            'transaction_reference',
            'receipt_path',
            'verified_by_admin_id',
        ]));
    }

    public function test_models_create_a_complete_tenant_auth_and_subscription_graph(): void
    {
        $owner = User::factory()->create([
            'phone_e164' => '+923001234567',
        ]);

        $business = Business::create([
            'name' => 'Ayesha Tailors',
            'slug' => 'ayesha-tailors',
            'phone_e164' => $owner->phone_e164,
            'created_by_user_id' => $owner->id,
        ]);

        $membership = BusinessMember::create([
            'business_id' => $business->id,
            'user_id' => $owner->id,
            'role' => BusinessRole::Owner,
            'status' => MembershipStatus::Active,
            'joined_at' => now(),
        ]);

        $device = Device::create([
            'user_id' => $owner->id,
            'installation_uuid' => (string) Str::uuid(),
            'device_model' => 'Test Android',
            'os_version' => '7.0',
            'app_version' => '1.0.0',
        ]);

        $session = AuthSession::create([
            'user_id' => $owner->id,
            'device_id' => $device->id,
            'access_token_hash' => hash('sha256', 'access-token'),
            'refresh_token_hash' => hash('sha256', 'refresh-token'),
            'access_expires_at' => now()->addMinutes(15),
            'refresh_expires_at' => now()->addDays(30),
        ]);

        $plan = Plan::create([
            'code' => 'starter-monthly',
            'name' => 'Starter',
            'billing_period' => BillingPeriod::Monthly,
            'price' => 1500,
            'trial_days' => 14,
            'features' => ['cloud_backup' => true],
            'limits' => ['staff' => 3],
            'is_active' => true,
        ]);

        $admin = AdminUser::create([
            'name' => 'System Admin',
            'email' => 'admin@example.test',
            'password' => 'test-password',
            'role' => AdminRole::Superadmin,
        ]);

        $subscription = Subscription::create([
            'business_id' => $business->id,
            'plan_id' => $plan->id,
            'source' => SubscriptionSource::Trial,
            'status' => SubscriptionStatus::Trialing,
            'starts_at' => now(),
            'expires_at' => now()->addDays(14),
            'activated_by_admin_id' => $admin->id,
        ]);

        $payment = SubscriptionPayment::create([
            'business_id' => $business->id,
            'subscription_id' => $subscription->id,
            'plan_id' => $plan->id,
            'method' => PaymentMethod::BankTransfer,
            'amount' => 1500,
            'transaction_reference' => 'PK-BANK-0001',
            'status' => PaymentStatus::Verified,
            'submitted_by_user_id' => $owner->id,
            'verified_by_admin_id' => $admin->id,
            'paid_at' => now(),
            'submitted_at' => now(),
            'verified_at' => now(),
        ]);

        $this->assertTrue(Str::isUlid($owner->id));
        $this->assertTrue(Str::isUlid($business->id));
        $this->assertSame(BusinessRole::Owner, $membership->role);
        $this->assertSame($session->id, $device->authSessions()->sole()->id);
        $this->assertSame($owner->id, $business->creator->id);
        $this->assertSame(SubscriptionStatus::Trialing, $subscription->status);
        $this->assertSame(PaymentMethod::BankTransfer, $payment->method);
        $this->assertSame($admin->id, $payment->verifiedBy->id);
    }
}
