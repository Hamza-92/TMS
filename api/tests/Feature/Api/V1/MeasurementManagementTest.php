<?php

namespace Tests\Feature\Api\V1;

use App\Enums\BusinessRole;
use App\Enums\MembershipStatus;
use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Customer;
use App\Models\MeasurementTemplate;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\User;
use Database\Seeders\MeasurementTemplateSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class MeasurementManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_system_templates_are_available_to_authenticated_businesses_and_are_not_tenant_owned(): void
    {
        $this->seed(MeasurementTemplateSeeder::class);
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);

        $this->getJson("/api/v1/businesses/{$business->id}/measurement-templates")
            ->assertUnauthorized();

        $response = $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/measurement-templates")
            ->assertOk()
            ->assertJsonPath('meta.total', 5)
            ->assertJsonPath('data.0.source', 'system');

        $templateUuid = $response->json('data.0.client_uuid');
        $this->withToken($token)
            ->deleteJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}", [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
            ])
            ->assertNotFound();
    }

    public function test_owner_can_create_and_version_a_business_template_with_idempotent_replay(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $templateUuid = (string) Str::uuid();
        $operationUuid = (string) Str::uuid();
        $fieldUuid = (string) Str::uuid();
        $payload = $this->templatePayload($operationUuid, $fieldUuid);

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}", $payload)
            ->assertCreated()
            ->assertJsonPath('data.client_uuid', $templateUuid)
            ->assertJsonPath('data.source', 'business')
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('data.current_definition_version', 1)
            ->assertJsonPath('data.fields.0.field_key', 'coat_length')
            ->assertJsonPath('meta.replayed', false);

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}", $payload)
            ->assertOk()
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('meta.replayed', true);

        $updated = [
            ...$payload,
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 1,
            'name' => 'Formal Coat',
        ];
        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}", $updated)
            ->assertOk()
            ->assertJsonPath('data.name', 'Formal Coat')
            ->assertJsonPath('data.version', 2)
            ->assertJsonPath('data.current_definition_version', 2);

        $this->assertDatabaseCount('measurement_templates', 1);
        $this->assertDatabaseCount('measurement_template_versions', 2);
        $this->assertDatabaseCount('measurement_operations', 2);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}/versions/1")
            ->assertOk()
            ->assertJsonPath('data.name', 'Coat')
            ->assertJsonPath('data.version_number', 1)
            ->assertJsonPath('data.fields.0.client_uuid', $fieldUuid);

        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/measurement-templates/{$templateUuid}", [
                ...$updated,
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
            ])
            ->assertConflict()
            ->assertJsonPath('code', 'measurement_template_version_conflict')
            ->assertJsonPath('data.template.version', 2);
    }

    public function test_staff_can_read_templates_but_only_owner_or_manager_can_change_them(): void
    {
        [$owner, $business] = $this->businessContext();
        $staff = User::factory()->create([
            'phone_e164' => '+923001112222',
            'password' => 'Tailor123',
        ]);
        BusinessMember::query()->create([
            'business_id' => $business->id,
            'user_id' => $staff->id,
            'role' => BusinessRole::Staff,
            'status' => MembershipStatus::Active,
            'joined_at' => now(),
        ]);
        $token = $this->login($staff);

        $this->withToken($token)
            ->getJson("/api/v1/businesses/{$business->id}/measurement-templates")
            ->assertOk();

        $this->withToken($token)
            ->putJson(
                "/api/v1/businesses/{$business->id}/measurement-templates/".(string) Str::uuid(),
                $this->templatePayload((string) Str::uuid(), (string) Str::uuid()),
            )
            ->assertForbidden()
            ->assertJsonPath('code', 'measurement_template_permission_denied');

        $this->assertNotNull($owner);
    }

    public function test_customer_profile_revisions_are_immutable_normalized_and_idempotent(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $customer = $this->createCustomer($token, $business);
        [$template, $fieldUuid] = $this->createTemplate($token, $business);
        $profileUuid = (string) Str::uuid();
        $profilePayload = [
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 0,
            'template_client_uuid' => $template->client_uuid,
            'template_definition_version' => 1,
            'name' => 'Regular coat',
            'preferred_unit' => 'inch',
            'notes' => null,
        ];

        $this->withToken($token)
            ->putJson($this->profileUrl($business, $customer, $profileUuid), $profilePayload)
            ->assertCreated()
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('data.latest_revision_number', 0);

        $revisionUuid = (string) Str::uuid();
        $revisionPayload = [
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 1,
            'revision_client_uuid' => $revisionUuid,
            'measured_at' => '2026-09-08T10:30:00+05:00',
            'values' => [[
                'field_uuid' => $fieldUuid,
                'value' => 40.25,
                'unit' => 'inch',
            ]],
            'notes' => 'Allow a little ease.',
        ];

        $this->withToken($token)
            ->postJson($this->profileUrl($business, $customer, $profileUuid).'/revisions', $revisionPayload)
            ->assertCreated()
            ->assertJsonPath('data.profile.version', 2)
            ->assertJsonPath('data.profile.latest_revision_number', 1)
            ->assertJsonPath('data.revision.client_uuid', $revisionUuid)
            ->assertJsonPath('data.revision.values.0.unit', 'inch')
            ->assertJsonPath('data.revision.values.0.value_mm', '1022.35')
            ->assertJsonPath('meta.replayed', false);

        $this->withToken($token)
            ->postJson($this->profileUrl($business, $customer, $profileUuid).'/revisions', $revisionPayload)
            ->assertOk()
            ->assertJsonPath('data.profile.version', 2)
            ->assertJsonPath('meta.replayed', true);

        $this->assertDatabaseCount('customer_measurement_revisions', 1);
        $this->assertDatabaseCount('measurement_operations', 3);
    }

    public function test_revision_rejects_missing_required_or_foreign_template_fields(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $customer = $this->createCustomer($token, $business);
        [$template] = $this->createTemplate($token, $business);
        $profileUuid = (string) Str::uuid();

        $this->withToken($token)->putJson($this->profileUrl($business, $customer, $profileUuid), [
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 0,
            'template_client_uuid' => $template->client_uuid,
            'template_definition_version' => 1,
            'name' => 'Coat',
            'preferred_unit' => 'cm',
        ])->assertCreated();

        $this->withToken($token)
            ->postJson($this->profileUrl($business, $customer, $profileUuid).'/revisions', [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
                'revision_client_uuid' => (string) Str::uuid(),
                'measured_at' => now()->toIso8601String(),
                'values' => [[
                    'field_uuid' => (string) Str::uuid(),
                    'value' => 50,
                    'unit' => 'cm',
                ]],
            ])
            ->assertUnprocessable()
            ->assertJsonPath('code', 'validation_failed')
            ->assertJsonValidationErrors(['values', 'values.0.field_uuid']);

        $this->assertDatabaseCount('customer_measurement_revisions', 0);
    }

    public function test_profiles_are_customer_and_business_scoped_and_can_be_archived_and_restored(): void
    {
        [$user, $business] = $this->businessContext();
        $token = $this->login($user);
        $customer = $this->createCustomer($token, $business);
        $otherCustomer = $this->createCustomer($token, $business, 'Other Customer');
        [$template] = $this->createTemplate($token, $business);
        $profileUuid = (string) Str::uuid();

        $this->withToken($token)->putJson($this->profileUrl($business, $customer, $profileUuid), [
            'operation_uuid' => (string) Str::uuid(),
            'base_version' => 0,
            'template_client_uuid' => $template->client_uuid,
            'template_definition_version' => 1,
            'name' => 'Regular coat',
            'preferred_unit' => 'inch',
        ])->assertCreated();

        $this->withToken($token)
            ->getJson($this->profileUrl($business, $otherCustomer, $profileUuid))
            ->assertNotFound();

        $this->withToken($token)
            ->deleteJson($this->profileUrl($business, $customer, $profileUuid), [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 1,
            ])
            ->assertOk()
            ->assertJsonPath('data.status', 'archived')
            ->assertJsonPath('data.version', 2);

        $this->withToken($token)
            ->postJson($this->profileUrl($business, $customer, $profileUuid).'/restore', [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 2,
            ])
            ->assertOk()
            ->assertJsonPath('data.status', 'active')
            ->assertJsonPath('data.version', 3);
    }

    /** @return array{User, Business, Subscription} */
    private function businessContext(): array
    {
        $user = User::factory()->create([
            'phone_e164' => '+92300'.random_int(1000000, 9999999),
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
            'limits' => ['customers' => 250],
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
            'device_model' => 'Measurement API test',
        ])->assertOk()->json('data.tokens.access_token');
    }

    private function createCustomer(string $token, Business $business, string $name = 'Ayesha Khan'): Customer
    {
        $uuid = (string) Str::uuid();
        $this->withToken($token)
            ->putJson("/api/v1/businesses/{$business->id}/customers/{$uuid}", [
                'operation_uuid' => (string) Str::uuid(),
                'base_version' => 0,
                'name' => $name,
            ])
            ->assertCreated();

        return Customer::query()->where('client_uuid', $uuid)->firstOrFail();
    }

    /** @return array{MeasurementTemplate, string} */
    private function createTemplate(string $token, Business $business): array
    {
        $uuid = (string) Str::uuid();
        $fieldUuid = (string) Str::uuid();
        $this->withToken($token)
            ->putJson(
                "/api/v1/businesses/{$business->id}/measurement-templates/{$uuid}",
                $this->templatePayload((string) Str::uuid(), $fieldUuid),
            )
            ->assertCreated();

        return [MeasurementTemplate::query()->where('client_uuid', $uuid)->firstOrFail(), $fieldUuid];
    }

    /** @return array<string, mixed> */
    private function templatePayload(string $operationUuid, string $fieldUuid): array
    {
        return [
            'operation_uuid' => $operationUuid,
            'base_version' => 0,
            'name' => 'Coat',
            'name_ur' => 'کوٹ',
            'name_roman_ur' => 'Coat',
            'category' => 'coat',
            'default_unit' => 'inch',
            'fields' => [[
                'client_uuid' => $fieldUuid,
                'field_key' => 'coat_length',
                'label' => 'Coat length',
                'label_ur' => 'کوٹ کی لمبائی',
                'label_roman_ur' => 'Coat ki lambai',
                'section' => 'garment',
                'value_type' => 'number',
                'unit_type' => 'length',
                'is_required' => true,
                'minimum_value_mm' => 100,
                'maximum_value_mm' => 2000,
                'sort_order' => 0,
            ]],
        ];
    }

    private function profileUrl(Business $business, Customer $customer, string $profileUuid): string
    {
        return "/api/v1/businesses/{$business->id}/customers/{$customer->client_uuid}/measurement-profiles/{$profileUuid}";
    }
}
