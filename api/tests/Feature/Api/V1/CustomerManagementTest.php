<?php

namespace Tests\Feature\Api\V1;

use App\Enums\BusinessRole;
use App\Enums\MembershipStatus;
use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Customer;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\TestCase;

class CustomerManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_customer_api_is_authenticated_and_business_scoped(): void
    {
        [$user, $business] = $this->businessContext();
        [, $otherBusiness] = $this->businessContext('+923009999998');

        $this->getJson("/api/v1/businesses/{$business->id}/customers")
            ->assertUnauthorized();

        $token = $this->login($user);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$otherBusiness->id}/customers")
            ->assertForbidden()
            ->assertJsonPath('code', 'business_access_denied');

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/customers")
            ->assertOk()
            ->assertJsonPath('meta.total', 0);
    }

    public function test_customer_changes_are_idempotent_searchable_and_versioned(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $clientUuid = (string) Str::uuid();
        $operationUuid = (string) Str::uuid();
        $payload = [
            'operation_uuid' => $operationUuid,
            'base_version' => 0,
            'name' => 'Ayesha Khan',
            'phone_e164' => '+923001234567',
            'alternate_phone_e164' => null,
            'address' => 'Model Town, Lahore',
            'notes' => 'Prefers WhatsApp updates.',
        ];

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", $payload)
            ->assertCreated()
            ->assertJsonPath('data.client_uuid', $clientUuid)
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('data.status', 'active');

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", $payload)
            ->assertOk()
            ->assertJsonPath('meta.replayed', true)
            ->assertJsonPath('data.version', 1);

        $this->assertDatabaseCount('customers', 1);
        $this->assertDatabaseCount('customer_operations', 1);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/customers?search=9230012")
            ->assertOk()
            ->assertJsonPath('meta.total', 1)
            ->assertJsonPath('data.0.name', 'Ayesha Khan');

        $update = [...$payload,
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 1,
            'name' => 'Ayesha Ahmed',
        ];

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", $update)
            ->assertOk()
            ->assertJsonPath('data.name', 'Ayesha Ahmed')
            ->assertJsonPath('data.version', 2);

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", [
                ...$update,
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
                'name' => 'Stale change',
            ])
            ->assertConflict()
            ->assertJsonPath('code', 'customer_version_conflict')
            ->assertJsonPath('data.customer.name', 'Ayesha Ahmed')
            ->assertJsonPath('data.customer.version', 2);
    }

    public function test_customer_can_be_archived_and_restored_without_losing_sync_history(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $clientUuid = (string) Str::uuid();
        $this->createCustomer($token, $business, $clientUuid);

        $this->withToken($token)
            ->deleteJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
            ])
            ->assertOk()
            ->assertJsonPath('data.status', 'archived')
            ->assertJsonPath('data.version', 2);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/customers")
            ->assertJsonPath('meta.total', 0);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/customers?status=all")
            ->assertJsonPath('meta.total', 1)
            ->assertJsonPath('data.0.status', 'archived');

        $this->withToken($token)
            ->postJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}/restore", [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 2,
            ])
            ->assertOk()
            ->assertJsonPath('data.status', 'active')
            ->assertJsonPath('data.version', 3);
    }

    public function test_subscription_customer_limit_and_expiry_are_enforced(): void
    {
        [$user, $business, $subscription] = $this->businessContext(customerLimit: 1);
        $token = $this->login($user);
        $this->createCustomer($token, $business, (string) Str::uuid());

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/".(string) Str::uuid(), [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 0,
                'name' => 'Second Customer',
            ])
            ->assertUnprocessable()
            ->assertJsonPath('code', 'customer_limit_reached')
            ->assertJsonPath('data.limit', 1);

        $subscription->forceFill([
            'expires_at' => now()->subDay(),
            'offline_grace_until' => now()->subMinute(),
        ])->save();

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/customers")
            ->assertForbidden()
            ->assertJsonPath('code', 'subscription_expired');
    }

    public function test_customer_photo_can_be_uploaded_and_removed(): void
    {
        Storage::fake('public');
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $clientUuid = (string) Str::uuid();
        $customer = $this->createCustomer($token, $business, $clientUuid);

        $this->withToken($token)
            ->post("/api/v1/businesses/{$business->id}/customers/{$clientUuid}/photo", [
                'photo' => UploadedFile::fake()->image('customer.jpg', 480, 480),
            ])
            ->assertOk()
            ->assertJsonPath('data.client_uuid', $clientUuid)
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('data.photo_url', fn ($value): bool => is_string($value) && $value !== '');

        $photoPath = $customer->fresh()->photo_path;
        $this->assertNotNull($photoPath);
        Storage::disk('public')->assertExists($photoPath);

        $this->withToken($token)
            ->deleteJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}/photo")
            ->assertOk()
            ->assertJsonPath('data.photo_url', null);

        Storage::disk('public')->assertMissing($photoPath);
    }

    /** @return array{User, Business, Subscription} */
    private function businessContext(string $phone = '+923009999999', int $customerLimit = 250): array
    {
        $user = User::factory()->create([
            'phone_e164' => $phone,
            'password' => 'Tailor123',
        ]);
        $business = Business::query()->create([
            'name' => 'Test Tailors',
            'slug' => 'test-tailors-'.Str::lower(Str::random(8)),
            'created_by_user_id' => $user->id,
        ]);
        BusinessMember::query()->create([
            'business_id' => $business->id,
            'user_id' => $user->id,
            'role' => BusinessRole::Owner,
            'status' => MembershipStatus::Active,
            'joined_at' => now(),
        ]);
        $plan = Plan::query()->create([
            'code' => 'test-'.Str::lower(Str::random(8)),
            'name' => 'Test plan',
            'limits' => ['customers' => $customerLimit],
        ]);
        $subscription = Subscription::query()->create([
            'business_id' => $business->id,
            'plan_id' => $plan->id,
            'source' => SubscriptionSource::Complimentary,
            'status' => SubscriptionStatus::Active,
            'starts_at' => now()->subDay(),
            'expires_at' => now()->addMonth(),
            'offline_grace_until' => now()->addMonth()->addDays(3),
        ]);

        return [$user, $business, $subscription];
    }

    private function login(User $user): string
    {
        return $this->postJson('/api/v1/auth/login', [
            'phone_e164' => $user->phone_e164,
            'password' => 'Tailor123',
            'installation_uuid' => (string) Str::uuid(),
            'device_model' => 'Customer API test',
        ])->assertOk()->json('data.tokens.access_token');
    }

    private function createCustomer(string $token, Business $business, string $clientUuid): Customer
    {
        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$clientUuid}", [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 0,
                'name' => 'Ayesha Khan',
                'phone_e164' => '+923001234567',
            ])
            ->assertCreated();

        return Customer::query()->where('client_uuid', $clientUuid)->firstOrFail();
    }
}
