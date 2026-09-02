<?php

namespace Tests\Feature\Admin;

use App\Models\AdminUser;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AdminAuthenticationTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_is_redirected_to_the_admin_login_page(): void
    {
        $this->get('/admin')
            ->assertRedirect('/admin/login');

        $this->get('/admin/login')
            ->assertOk()
            ->assertViewIs('admin.auth.login')
            ->assertSee('Welcome back');
    }

    public function test_mobile_web_session_does_not_authorize_the_admin_portal(): void
    {
        $user = User::query()->create([
            'name' => 'Mobile Customer',
            'phone_e164' => '+923001234567',
            'phone_verified_at' => now(),
            'preferred_locale' => 'en',
            'status' => 'active',
        ]);

        $this->actingAs($user, 'web')
            ->get('/admin')
            ->assertRedirect('/admin/login');

        $this->assertGuest('admin');
    }

    public function test_active_admin_can_sign_in_and_open_the_dashboard(): void
    {
        $admin = $this->createAdmin();

        $this->post('/admin/login', [
            'email' => 'ADMIN@EXAMPLE.COM',
            'password' => 'SecurePass123',
            'remember' => true,
        ])->assertRedirect('/admin');

        $this->assertAuthenticatedAs($admin, 'admin');
        $this->assertNotNull($admin->fresh()->last_login_at);
        $this->assertDatabaseHas('admin_audit_logs', [
            'admin_user_id' => $admin->id,
            'action' => 'admin.signed_in',
        ]);

        $this->get('/admin')
            ->assertOk()
            ->assertViewIs('admin.dashboard')
            ->assertSee('Platform overview')
            ->assertSee('Total businesses');
    }

    public function test_invalid_credentials_return_a_generic_error(): void
    {
        $this->createAdmin();

        $this->from('/admin/login')->post('/admin/login', [
            'email' => 'admin@example.com',
            'password' => 'WrongPassword123',
        ])->assertRedirect('/admin/login')
            ->assertSessionHasErrors([
                'email' => 'The email or password is incorrect.',
            ]);

        $this->assertGuest('admin');
    }

    public function test_blocked_admin_cannot_sign_in(): void
    {
        $this->createAdmin(['status' => 'blocked']);

        $this->from('/admin/login')->post('/admin/login', [
            'email' => 'admin@example.com',
            'password' => 'SecurePass123',
        ])->assertRedirect('/admin/login')
            ->assertSessionHasErrors('email');

        $this->assertGuest('admin');
    }

    public function test_admin_is_signed_out_if_access_is_blocked_during_a_session(): void
    {
        $admin = $this->createAdmin();
        $this->actingAs($admin, 'admin');
        $admin->update(['status' => 'blocked']);

        $this->get('/admin')
            ->assertRedirect('/admin/login')
            ->assertSessionHasErrors('email');

        $this->assertGuest('admin');
    }

    public function test_admin_can_sign_out_and_the_action_is_audited(): void
    {
        $admin = $this->createAdmin();
        $this->actingAs($admin, 'admin');

        $this->post('/admin/logout')
            ->assertRedirect('/admin/login')
            ->assertSessionHas('status', 'You have been signed out securely.');

        $this->assertGuest('admin');
        $this->assertDatabaseHas('admin_audit_logs', [
            'admin_user_id' => $admin->id,
            'action' => 'admin.signed_out',
        ]);
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
