<?php

namespace App\Http\Middleware;

use App\Enums\UserStatus;
use App\Models\AuthSession;
use Closure;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AuthenticateAccessToken
{
    public function handle(Request $request, Closure $next): Response
    {
        $plainToken = $request->bearerToken();

        if (! is_string($plainToken) || $plainToken === '') {
            return $this->unauthenticated();
        }

        $session = AuthSession::query()
            ->with(['user', 'device'])
            ->where('access_token_hash', hash('sha256', $plainToken))
            ->first();

        if (
            ! $session
            || $session->revoked_at
            || $session->access_expires_at->isPast()
            || $session->device->revoked_at
            || $session->user->status !== UserStatus::Active
        ) {
            return $this->unauthenticated();
        }

        if (! $session->last_used_at || $session->last_used_at->lt(now()->subMinutes(5))) {
            $session->forceFill(['last_used_at' => now()])->save();
        }

        $request->setUserResolver(fn () => $session->user);
        $request->attributes->set('auth_session', $session);

        return $next($request);
    }

    private function unauthenticated(): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => 'Authentication is required.',
            'code' => 'unauthenticated',
        ], 401);
    }
}
