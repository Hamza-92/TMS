<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Enums\OtpPurpose;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\Auth\CompleteRegistrationRequest;
use App\Http\Requests\Api\V1\Auth\LoginRequest;
use App\Http\Requests\Api\V1\Auth\RefreshTokenRequest;
use App\Http\Requests\Api\V1\Auth\RequestRegistrationOtpRequest;
use App\Http\Resources\Api\V1\BusinessResource;
use App\Http\Resources\Api\V1\SubscriptionResource;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\User;
use App\Services\Auth\AuthenticationService;
use App\Services\Auth\AuthTokenService;
use App\Services\Auth\OtpService;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function __construct(
        private readonly OtpService $otpService,
        private readonly AuthenticationService $authenticationService,
        private readonly AuthTokenService $tokenService,
    ) {}

    public function requestRegistrationOtp(RequestRegistrationOtpRequest $request): JsonResponse
    {
        $data = $request->validated();

        if (User::query()->where('phone_e164', $data['phone_e164'])->exists()) {
            throw ValidationException::withMessages([
                'phone_e164' => ['An account already exists for this phone number.'],
            ]);
        }

        $challenge = $this->otpService->issue(
            $data['phone_e164'],
            OtpPurpose::Registration,
            $data['installation_uuid'],
            $request->ip(),
        );

        return response()->json([
            'success' => true,
            'message' => 'A verification code has been sent through WhatsApp.',
            'data' => [
                'otp_challenge_id' => $challenge->id,
                'expires_at' => $challenge->expires_at->toIso8601String(),
                'resend_after_seconds' => (int) config('authentication.otp.resend_cooldown_seconds'),
            ],
        ], 202);
    }

    public function completeRegistration(CompleteRegistrationRequest $request): JsonResponse
    {
        $data = $request->validated();
        $this->otpService->verify(
            $data['otp_challenge_id'],
            $data['otp'],
            OtpPurpose::Registration,
        );

        $result = $this->authenticationService->register($data, $request);
        $result['subscription']->load('plan');

        return response()->json([
            'success' => true,
            'message' => 'Your account and demo subscription are ready.',
            'data' => [
                'user' => UserResource::make($result['user'])->resolve($request),
                'business' => BusinessResource::make($result['business'])->resolve($request),
                'subscription' => SubscriptionResource::make($result['subscription'])->resolve($request),
                'tokens' => $result['tokens'],
            ],
        ], 201);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $result = $this->authenticationService->login($request->validated(), $request);

        return response()->json([
            'success' => true,
            'message' => 'Signed in successfully.',
            'data' => [
                'user' => UserResource::make($result['user'])->resolve($request),
                'tokens' => $result['tokens'],
            ],
        ]);
    }

    public function refresh(RefreshTokenRequest $request): JsonResponse
    {
        $tokens = $this->tokenService->refresh($request->validated('refresh_token'), $request);

        return response()->json([
            'success' => true,
            'message' => 'Authentication tokens refreshed.',
            'data' => ['tokens' => $tokens],
        ]);
    }
}
