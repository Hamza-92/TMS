<?php

namespace Tests\Feature\Api\V1;

use App\Contracts\OtpDeliveryGateway;
use App\Enums\WhatsAppMessageStatus;
use App\Models\AuthSession;
use App\Models\OtpChallenge;
use App\Models\User;
use Database\Seeders\PlanSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase;

    private FakeOtpDeliveryGateway $otpGateway;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(PlanSeeder::class);
        $this->otpGateway = new FakeOtpDeliveryGateway;
        $this->app->instance(OtpDeliveryGateway::class, $this->otpGateway);
    }

    public function test_customer_can_register_and_receives_an_automatic_demo_subscription(): void
    {
        $installationUuid = '11111111-1111-4111-8111-111111111111';

        $otpResponse = $this->postJson('/api/v1/auth/register/request-otp', [
            'phone_e164' => '+923001111111',
            'installation_uuid' => $installationUuid,
            'device_model' => 'Budget Android',
            'os_version' => '7.0',
            'app_version' => '1.0.0',
        ])->assertAccepted()
            ->assertJsonPath('success', true)
            ->assertJsonStructure(['data' => ['otp_challenge_id', 'expires_at']]);

        $challengeId = $otpResponse->json('data.otp_challenge_id');

        $registrationResponse = $this->postJson('/api/v1/auth/register', [
            'otp_challenge_id' => $challengeId,
            'otp' => $this->otpGateway->codeFor($challengeId),
            'name' => 'Ayesha Khan',
            'business_name' => 'Ayesha Tailors',
            'preferred_locale' => 'ur',
            'password' => 'Tailor123',
            'password_confirmation' => 'Tailor123',
            'installation_uuid' => $installationUuid,
            'device_model' => 'Budget Android',
            'os_version' => '7.0',
            'app_version' => '1.0.0',
        ])->assertCreated()
            ->assertJsonPath('data.user.phone_e164', '+923001111111')
            ->assertJsonPath('data.user.preferred_locale', 'ur')
            ->assertJsonPath('data.business.name', 'Ayesha Tailors')
            ->assertJsonPath('data.subscription.plan_code', 'demo')
            ->assertJsonPath('data.subscription.status', 'trialing')
            ->assertJsonStructure(['data' => ['tokens' => ['access_token', 'refresh_token']]]);

        $this->assertDatabaseCount('users', 1);
        $this->assertDatabaseCount('businesses', 1);
        $this->assertDatabaseCount('business_members', 1);
        $this->assertDatabaseCount('subscriptions', 1);
        $this->assertDatabaseCount('trial_claims', 1);
        $this->assertDatabaseCount('auth_sessions', 1);
        $this->assertDatabaseHas('otp_challenges', [
            'id' => $challengeId,
            'status' => 'consumed',
        ]);

        $accessToken = $registrationResponse->json('data.tokens.access_token');
        $this->withToken($accessToken)
            ->getJson('/api/v1/auth/me')
            ->assertOk()
            ->assertJsonPath('data.businesses.0.role', 'owner');
    }

    public function test_customer_can_login_refresh_tokens_and_logout(): void
    {
        User::factory()->create([
            'phone_e164' => '+923002222222',
            'password' => 'Tailor123',
        ]);

        $loginResponse = $this->postJson('/api/v1/auth/login', [
            'phone_e164' => '+923002222222',
            'password' => 'Tailor123',
            'installation_uuid' => '22222222-2222-4222-8222-222222222222',
            'device_model' => 'Android Phone',
        ])->assertOk();

        $oldAccessToken = $loginResponse->json('data.tokens.access_token');
        $oldRefreshToken = $loginResponse->json('data.tokens.refresh_token');

        $refreshResponse = $this->postJson('/api/v1/auth/token/refresh', [
            'refresh_token' => $oldRefreshToken,
        ])->assertOk();

        $newAccessToken = $refreshResponse->json('data.tokens.access_token');
        $this->assertNotSame($oldAccessToken, $newAccessToken);

        $this->withToken($oldAccessToken)
            ->getJson('/api/v1/auth/me')
            ->assertUnauthorized();

        $this->postJson('/api/v1/auth/token/refresh', [
            'refresh_token' => $oldRefreshToken,
        ])->assertUnprocessable();

        $this->withToken($newAccessToken)
            ->postJson('/api/v1/auth/logout')
            ->assertOk();

        $this->withToken($newAccessToken)
            ->getJson('/api/v1/auth/me')
            ->assertUnauthorized();
    }

    public function test_password_reset_revokes_existing_sessions_and_allows_the_new_password(): void
    {
        User::factory()->create([
            'phone_e164' => '+923003333333',
            'password' => 'OldPass123',
        ]);
        $installationUuid = '33333333-3333-4333-8333-333333333333';

        $loginResponse = $this->postJson('/api/v1/auth/login', [
            'phone_e164' => '+923003333333',
            'password' => 'OldPass123',
            'installation_uuid' => $installationUuid,
        ])->assertOk();

        $oldAccessToken = $loginResponse->json('data.tokens.access_token');

        $otpResponse = $this->postJson('/api/v1/auth/password/request-otp', [
            'phone_e164' => '+923003333333',
            'installation_uuid' => $installationUuid,
        ])->assertAccepted();
        $challengeId = $otpResponse->json('data.otp_challenge_id');

        $verifyResponse = $this->postJson('/api/v1/auth/password/verify-otp', [
            'otp_challenge_id' => $challengeId,
            'otp' => $this->otpGateway->codeFor($challengeId),
        ])->assertOk();

        $this->postJson('/api/v1/auth/password/reset', [
            'otp_challenge_id' => $challengeId,
            'reset_token' => $verifyResponse->json('data.reset_token'),
            'password' => 'NewPass456',
            'password_confirmation' => 'NewPass456',
        ])->assertOk();

        $this->withToken($oldAccessToken)
            ->getJson('/api/v1/auth/me')
            ->assertUnauthorized();

        $this->postJson('/api/v1/auth/login', [
            'phone_e164' => '+923003333333',
            'password' => 'OldPass123',
            'installation_uuid' => $installationUuid,
        ])->assertUnprocessable();

        $this->postJson('/api/v1/auth/login', [
            'phone_e164' => '+923003333333',
            'password' => 'NewPass456',
            'installation_uuid' => $installationUuid,
        ])->assertOk();

        $this->assertSame(1, AuthSession::query()->whereNull('revoked_at')->count());
    }

    public function test_password_recovery_does_not_reveal_whether_an_account_exists(): void
    {
        $response = $this->postJson('/api/v1/auth/password/request-otp', [
            'phone_e164' => '+923009999999',
            'installation_uuid' => '99999999-9999-4999-8999-999999999999',
        ])->assertAccepted();

        $response->assertJsonPath(
            'message',
            'If this phone number has an account, a verification code has been sent.',
        );
        $this->assertDatabaseCount('otp_challenges', 0);
    }

    public function test_incorrect_otp_attempt_is_persisted_without_creating_an_account(): void
    {
        $installationUuid = '44444444-4444-4444-8444-444444444444';
        $otpResponse = $this->postJson('/api/v1/auth/register/request-otp', [
            'phone_e164' => '+923004444444',
            'installation_uuid' => $installationUuid,
        ])->assertAccepted();
        $challengeId = $otpResponse->json('data.otp_challenge_id');
        $wrongCode = $this->otpGateway->codeFor($challengeId) === '000000' ? '111111' : '000000';

        $this->postJson('/api/v1/auth/register', [
            'otp_challenge_id' => $challengeId,
            'otp' => $wrongCode,
            'name' => 'Test Customer',
            'business_name' => 'Test Tailors',
            'preferred_locale' => 'en',
            'password' => 'Tailor123',
            'password_confirmation' => 'Tailor123',
            'installation_uuid' => $installationUuid,
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('otp');

        $this->assertDatabaseHas('otp_challenges', [
            'id' => $challengeId,
            'attempt_count' => 1,
            'status' => 'pending',
        ]);
        $this->assertDatabaseCount('users', 0);
    }
}

class FakeOtpDeliveryGateway implements OtpDeliveryGateway
{
    /** @var array<string, string> */
    private array $codes = [];

    public function send(OtpChallenge $challenge, string $plainCode): void
    {
        $this->codes[$challenge->id] = $plainCode;
        $challenge->messages()->create([
            'provider' => 'fake',
            'template_name' => 'authentication_otp',
            'recipient_phone_e164' => $challenge->phone_e164,
            'status' => WhatsAppMessageStatus::Sent,
            'sent_at' => now(),
        ]);
        $challenge->forceFill(['sent_at' => now()])->save();
    }

    public function codeFor(string $challengeId): string
    {
        return $this->codes[$challengeId];
    }
}
