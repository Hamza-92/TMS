<?php

namespace Tests\Feature\Admin;

use App\Enums\OtpPurpose;
use App\Models\AdminUser;
use App\Services\Auth\OtpService;
use App\Services\Otp\StagingOtpVault;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Tests\TestCase;

class StagingOtpViewerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('admin.staging_tools_enabled', true);
        config()->set('authentication.otp.driver', 'log');
        Cache::clear();
    }

    public function test_superadmin_can_view_an_encrypted_pending_code(): void
    {
        $admin = $this->createAdmin();
        $challenge = app(OtpService::class)->issue(
            '+923001234567',
            OtpPurpose::Registration,
            '123e4567-e89b-12d3-a456-426614174000',
            '127.0.0.1',
        );

        $vault = app(StagingOtpVault::class);
        $plainCode = $vault->reveal($challenge);
        $cachedValue = Cache::get($vault->cacheKey($challenge->id));

        $this->assertMatchesRegularExpression('/^\d{6}$/', $plainCode);
        $this->assertIsString($cachedValue);
        $this->assertNotSame($plainCode, $cachedValue);
        $this->assertNotSame($plainCode, $challenge->code_hash);

        $this->actingAs($admin, 'admin')
            ->get('/admin/tools/otps')
            ->assertOk()
            ->assertSee('Test OTPs')
            ->assertSee('+923001234567')
            ->assertSee($plainCode);
    }

    public function test_code_disappears_immediately_after_successful_verification(): void
    {
        $admin = $this->createAdmin();
        $otpService = app(OtpService::class);
        $vault = app(StagingOtpVault::class);
        $challenge = $otpService->issue(
            '+923001234567',
            OtpPurpose::Registration,
            '123e4567-e89b-12d3-a456-426614174000',
            '127.0.0.1',
        );
        $plainCode = $vault->reveal($challenge);

        $otpService->verify($challenge->id, $plainCode, OtpPurpose::Registration);

        $this->assertNull($vault->reveal($challenge->refresh()));
        $this->assertNull(Cache::get($vault->cacheKey($challenge->id)));

        $this->actingAs($admin, 'admin')
            ->get('/admin/tools/otps')
            ->assertOk()
            ->assertDontSee($plainCode);
    }

    public function test_non_superadmin_cannot_view_codes(): void
    {
        $admin = $this->createAdmin(['role' => 'support']);

        $this->actingAs($admin, 'admin')
            ->get('/admin/tools/otps')
            ->assertForbidden();
    }

    public function test_route_is_hidden_when_the_tool_is_disabled(): void
    {
        config()->set('admin.staging_tools_enabled', false);
        $admin = $this->createAdmin();

        $this->actingAs($admin, 'admin')
            ->get('/admin/tools/otps')
            ->assertNotFound();
    }

    public function test_tool_cannot_be_enabled_in_production(): void
    {
        $this->app->detectEnvironment(fn (): string => 'production');
        $admin = $this->createAdmin();

        $this->actingAs($admin, 'admin')
            ->get('/admin/tools/otps')
            ->assertNotFound();
    }

    /** @param array<string, mixed> $overrides */
    private function createAdmin(array $overrides = []): AdminUser
    {
        return AdminUser::query()->create(array_merge([
            'name' => 'Platform Owner',
            'email' => 'admin@example.com',
            'email_verified_at' => now(),
            'password' => 'SecurePass123',
            'role' => 'superadmin',
            'status' => 'active',
        ], $overrides));
    }
}
