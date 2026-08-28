<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Enums\OtpPurpose;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\Auth\RequestPasswordOtpRequest;
use App\Http\Requests\Api\V1\Auth\ResetPasswordRequest;
use App\Http\Requests\Api\V1\Auth\VerifyPasswordOtpRequest;
use App\Models\User;
use App\Services\Auth\AuthenticationService;
use App\Services\Auth\OtpService;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;

class PasswordRecoveryController extends Controller
{
    public function __construct(
        private readonly OtpService $otpService,
        private readonly AuthenticationService $authenticationService,
    ) {}

    public function requestOtp(RequestPasswordOtpRequest $request): JsonResponse
    {
        $data = $request->validated();
        $user = User::query()->where('phone_e164', $data['phone_e164'])->first();
        $challengeId = (string) Str::ulid();
        $expiresAt = now()->addMinutes((int) config('authentication.otp.ttl_minutes'));

        if ($user) {
            $challenge = $this->otpService->issue(
                $user->phone_e164,
                OtpPurpose::ForgotPassword,
                $data['installation_uuid'],
                $request->ip(),
                $user,
            );
            $challengeId = $challenge->id;
            $expiresAt = $challenge->expires_at;
        }

        return response()->json([
            'success' => true,
            'message' => 'If this phone number has an account, a verification code has been sent.',
            'data' => [
                'otp_challenge_id' => $challengeId,
                'expires_at' => $expiresAt->toIso8601String(),
                'resend_after_seconds' => (int) config('authentication.otp.resend_cooldown_seconds'),
            ],
        ], 202);
    }

    public function verifyOtp(VerifyPasswordOtpRequest $request): JsonResponse
    {
        $data = $request->validated();
        $challenge = $this->otpService->verify(
            $data['otp_challenge_id'],
            $data['otp'],
            OtpPurpose::ForgotPassword,
        );
        $resetToken = $this->otpService->issueActionToken(
            $challenge->id,
            OtpPurpose::ForgotPassword,
        );

        return response()->json([
            'success' => true,
            'message' => 'Phone number verified. You may now choose a new password.',
            'data' => [
                'otp_challenge_id' => $challenge->id,
                'reset_token' => $resetToken,
                'expires_in_seconds' => (int) config('authentication.otp.action_token_ttl_minutes') * 60,
            ],
        ]);
    }

    public function reset(ResetPasswordRequest $request): JsonResponse
    {
        $data = $request->validated();
        $this->authenticationService->resetPassword(
            $data['otp_challenge_id'],
            $data['reset_token'],
            $data['password'],
        );

        return response()->json([
            'success' => true,
            'message' => 'Your password has been changed. Please sign in again.',
        ]);
    }
}
