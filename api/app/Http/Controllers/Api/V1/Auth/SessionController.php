<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller;
use App\Models\AuthSession;
use App\Models\User;
use App\Services\Auth\AuthBootstrapService;
use App\Services\Auth\AuthTokenService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SessionController extends Controller
{
    public function __construct(
        private readonly AuthTokenService $tokenService,
        private readonly AuthBootstrapService $bootstrapService,
    ) {}

    public function me(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        return response()->json([
            'success' => true,
            'data' => $this->bootstrapService->forUser($user, $request),
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
