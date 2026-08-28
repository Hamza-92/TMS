<?php

namespace App\Services\Auth;

use App\Enums\UserStatus;
use App\Models\AuthSession;
use App\Models\Device;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class AuthTokenService
{
    /** @return array<string, mixed> */
    public function issue(User $user, Device $device, Request $request): array
    {
        AuthSession::query()
            ->where('device_id', $device->id)
            ->whereNull('revoked_at')
            ->update([
                'revoked_at' => now(),
                'revocation_reason' => 'replaced_by_new_login',
            ]);

        return $this->createSession($user, $device, $request);
    }

    /** @return array<string, mixed> */
    public function refresh(string $plainRefreshToken, Request $request): array
    {
        $result = DB::transaction(function () use ($plainRefreshToken, $request): ?array {
            $session = AuthSession::query()
                ->with(['user', 'device'])
                ->where('refresh_token_hash', hash('sha256', $plainRefreshToken))
                ->lockForUpdate()
                ->first();

            if (
                ! $session
                || $session->revoked_at
                || $session->refresh_expires_at->isPast()
                || $session->device->revoked_at
                || $session->user->status !== UserStatus::Active
            ) {
                return null;
            }

            $accessToken = $this->generateToken();
            $refreshToken = $this->generateToken();
            $accessExpiresAt = now()->addMinutes((int) config('authentication.tokens.access_ttl_minutes'));
            $refreshExpiresAt = now()->addDays((int) config('authentication.tokens.refresh_ttl_days'));

            $session->forceFill([
                'access_token_hash' => hash('sha256', $accessToken),
                'refresh_token_hash' => hash('sha256', $refreshToken),
                'access_expires_at' => $accessExpiresAt,
                'refresh_expires_at' => $refreshExpiresAt,
                'last_refreshed_at' => now(),
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ])->save();

            return $this->tokenPayload($session, $accessToken, $refreshToken);
        });

        if (! $result) {
            throw ValidationException::withMessages([
                'refresh_token' => ['The refresh token is invalid or expired.'],
            ]);
        }

        return $result;
    }

    public function revoke(AuthSession $session, string $reason = 'logout'): void
    {
        $session->forceFill([
            'revoked_at' => now(),
            'revocation_reason' => $reason,
        ])->save();
    }

    public function revokeAll(User $user, string $reason = 'logout_all'): void
    {
        $user->authSessions()
            ->whereNull('revoked_at')
            ->update([
                'revoked_at' => now(),
                'revocation_reason' => $reason,
            ]);
    }

    /** @return array<string, mixed> */
    private function createSession(User $user, Device $device, Request $request): array
    {
        $accessToken = $this->generateToken();
        $refreshToken = $this->generateToken();

        $session = AuthSession::create([
            'user_id' => $user->id,
            'device_id' => $device->id,
            'access_token_hash' => hash('sha256', $accessToken),
            'refresh_token_hash' => hash('sha256', $refreshToken),
            'access_expires_at' => now()->addMinutes((int) config('authentication.tokens.access_ttl_minutes')),
            'refresh_expires_at' => now()->addDays((int) config('authentication.tokens.refresh_ttl_days')),
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return $this->tokenPayload($session, $accessToken, $refreshToken);
    }

    /** @return array<string, mixed> */
    private function tokenPayload(AuthSession $session, string $accessToken, string $refreshToken): array
    {
        return [
            'token_type' => 'Bearer',
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'access_expires_at' => $session->access_expires_at->toIso8601String(),
            'refresh_expires_at' => $session->refresh_expires_at->toIso8601String(),
        ];
    }

    private function generateToken(): string
    {
        return bin2hex(random_bytes(32));
    }
}
