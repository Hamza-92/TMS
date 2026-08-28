<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\AuthSession;
use App\Models\User;
use App\Services\Auth\AuthTokenService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SessionController extends Controller
{
    public function __construct(private readonly AuthTokenService $tokenService) {}

    public function me(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $memberships = $user->businessMemberships()->with('business')->get();

        return response()->json([
            'success' => true,
            'data' => [
                'user' => UserResource::make($user)->resolve($request),
                'businesses' => $memberships->map(fn ($membership): array => [
                    'id' => $membership->business->id,
                    'name' => $membership->business->name,
                    'role' => $membership->role->value,
                    'membership_status' => $membership->status->value,
                    'business_status' => $membership->business->status->value,
                ])->values(),
            ],
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        /** @var AuthSession $session */
        $session = $request->attributes->get('auth_session');
        $this->tokenService->revoke($session);

        return response()->json([
            'success' => true,
            'message' => 'Signed out from this device.',
        ]);
    }

    public function logoutAll(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $this->tokenService->revokeAll($user);

        return response()->json([
            'success' => true,
            'message' => 'Signed out from all devices.',
        ]);
    }
}
