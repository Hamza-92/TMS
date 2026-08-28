<?php

namespace App\Services\Auth;

use App\Contracts\OtpDeliveryGateway;
use App\Enums\OtpPurpose;
use App\Enums\OtpStatus;
use App\Models\OtpChallenge;
use App\Models\User;
use Closure;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OtpService
{
    public function __construct(private readonly OtpDeliveryGateway $deliveryGateway) {}

    public function issue(
        string $phoneE164,
        OtpPurpose $purpose,
        string $installationUuid,
        ?string $requestIp,
        ?User $user = null,
    ): OtpChallenge {
        $result = DB::transaction(function () use ($phoneE164, $purpose, $installationUuid, $requestIp, $user): array {
            $latest = OtpChallenge::query()
                ->where('phone_e164', $phoneE164)
                ->where('purpose', $purpose->value)
                ->latest('created_at')
                ->lockForUpdate()
                ->first();

            $cooldown = (int) config('authentication.otp.resend_cooldown_seconds');

            if ($latest && $latest->created_at->gt(now()->subSeconds($cooldown))) {
                return ['error' => 'Please wait before requesting another verification code.'];
            }

            $requestsThisHour = OtpChallenge::query()
                ->where('phone_e164', $phoneE164)
                ->where('purpose', $purpose->value)
                ->where('created_at', '>=', now()->subHour())
                ->count();

            if ($requestsThisHour >= (int) config('authentication.otp.max_requests_per_hour')) {
                return ['error' => 'Too many verification codes were requested. Please try again later.'];
            }

            OtpChallenge::query()
                ->where('phone_e164', $phoneE164)
                ->where('purpose', $purpose->value)
                ->where('status', OtpStatus::Pending->value)
                ->update(['status' => OtpStatus::Expired->value]);

            $plainCode = $this->generateCode();
            $challenge = OtpChallenge::create([
                'user_id' => $user?->id,
                'phone_e164' => $phoneE164,
                'purpose' => $purpose,
                'code_hash' => $this->hashSecret($plainCode),
                'provider' => (string) config('authentication.otp.driver'),
                'status' => OtpStatus::Pending,
                'max_attempts' => (int) config('authentication.otp.max_attempts'),
                'resend_count' => $requestsThisHour,
                'expires_at' => now()->addMinutes((int) config('authentication.otp.ttl_minutes')),
                'installation_uuid' => $installationUuid,
                'request_ip' => $requestIp,
            ]);

            return ['challenge' => $challenge, 'plain_code' => $plainCode];
        });

        if (isset($result['error'])) {
            throw ValidationException::withMessages(['phone_e164' => [$result['error']]]);
        }

        /** @var OtpChallenge $challenge */
        $challenge = $result['challenge'];
        $this->deliveryGateway->send($challenge, $result['plain_code']);

        return $challenge->refresh();
    }

    public function verify(string $challengeId, string $plainCode, OtpPurpose $purpose): OtpChallenge
    {
        $result = DB::transaction(function () use ($challengeId, $plainCode, $purpose): array {
            $challenge = OtpChallenge::query()->lockForUpdate()->find($challengeId);

            if (! $challenge || $challenge->purpose !== $purpose) {
                return ['error' => 'The verification request is invalid.'];
            }

            if ($challenge->status === OtpStatus::Consumed) {
                return ['error' => 'This verification code has already been used.'];
            }

            if ($challenge->status === OtpStatus::Blocked) {
                return ['error' => 'Too many incorrect attempts. Request a new verification code.'];
            }

            if ($challenge->expires_at->isPast() || $challenge->status === OtpStatus::Expired) {
                $challenge->forceFill(['status' => OtpStatus::Expired])->save();

                return ['error' => 'The verification code has expired.'];
            }

            if (! hash_equals($challenge->code_hash, $this->hashSecret($plainCode))) {
                $attemptCount = $challenge->attempt_count + 1;
                $challenge->forceFill([
                    'attempt_count' => $attemptCount,
                    'status' => $attemptCount >= $challenge->max_attempts
                        ? OtpStatus::Blocked
                        : OtpStatus::Pending,
                ])->save();

                return ['error' => 'The verification code is incorrect.'];
            }

            $challenge->forceFill([
                'status' => OtpStatus::Verified,
                'verified_at' => $challenge->verified_at ?? now(),
            ])->save();

            return ['challenge' => $challenge];
        });

        if (isset($result['error'])) {
            throw ValidationException::withMessages(['otp' => [$result['error']]]);
        }

        return $result['challenge'];
    }

    public function issueActionToken(string $challengeId, OtpPurpose $purpose): string
    {
        $plainToken = $this->generateToken();

        $updated = OtpChallenge::query()
            ->whereKey($challengeId)
            ->where('purpose', $purpose->value)
            ->where('status', OtpStatus::Verified->value)
            ->where('expires_at', '>', now())
            ->update([
                'action_token_hash' => $this->hashSecret($plainToken),
                'action_token_expires_at' => now()->addMinutes(
                    (int) config('authentication.otp.action_token_ttl_minutes'),
                ),
            ]);

        if ($updated !== 1) {
            throw ValidationException::withMessages(['otp' => ['The verification request is no longer valid.']]);
        }

        return $plainToken;
    }

    /**
     * @template TReturn
     *
     * @param  Closure(OtpChallenge): TReturn  $callback
     * @return TReturn
     */
    public function consumeVerified(string $challengeId, OtpPurpose $purpose, Closure $callback): mixed
    {
        return DB::transaction(function () use ($challengeId, $purpose, $callback): mixed {
            $challenge = OtpChallenge::query()->lockForUpdate()->find($challengeId);

            if (
                ! $challenge
                || $challenge->purpose !== $purpose
                || $challenge->status !== OtpStatus::Verified
                || $challenge->expires_at->isPast()
            ) {
                throw ValidationException::withMessages(['otp' => ['Verify a valid code before continuing.']]);
            }

            $result = $callback($challenge);

            $challenge->forceFill([
                'status' => OtpStatus::Consumed,
                'consumed_at' => now(),
            ])->save();

            return $result;
        });
    }

    /**
     * @template TReturn
     *
     * @param  Closure(OtpChallenge): TReturn  $callback
     * @return TReturn
     */
    public function consumeActionToken(
        string $challengeId,
        string $plainToken,
        OtpPurpose $purpose,
        Closure $callback,
    ): mixed {
        return DB::transaction(function () use ($challengeId, $plainToken, $purpose, $callback): mixed {
            $challenge = OtpChallenge::query()->lockForUpdate()->find($challengeId);

            if (
                ! $challenge
                || $challenge->purpose !== $purpose
                || $challenge->status !== OtpStatus::Verified
                || ! $challenge->action_token_hash
                || ! $challenge->action_token_expires_at
                || $challenge->action_token_expires_at->isPast()
                || ! hash_equals($challenge->action_token_hash, $this->hashSecret($plainToken))
            ) {
                throw ValidationException::withMessages(['reset_token' => ['The password reset token is invalid or expired.']]);
            }

            $result = $callback($challenge);

            $challenge->forceFill([
                'status' => OtpStatus::Consumed,
                'consumed_at' => now(),
                'action_token_hash' => null,
                'action_token_expires_at' => null,
            ])->save();

            return $result;
        });
    }

    private function generateCode(): string
    {
        $digits = (int) config('authentication.otp.digits');
        $maximum = (10 ** $digits) - 1;

        return str_pad((string) random_int(0, $maximum), $digits, '0', STR_PAD_LEFT);
    }

    private function generateToken(): string
    {
        return bin2hex(random_bytes(32));
    }

    private function hashSecret(string $secret): string
    {
        return hash_hmac('sha256', $secret, (string) config('app.key'));
    }
}
