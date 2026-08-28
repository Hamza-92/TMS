<?php

namespace App\Services\Auth;

use App\Enums\BusinessRole;
use App\Enums\MembershipStatus;
use App\Enums\OtpPurpose;
use App\Enums\SubscriptionActorType;
use App\Enums\SubscriptionEventType;
use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use App\Enums\UserStatus;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\Device;
use App\Models\OtpChallenge;
use App\Models\Plan;
use App\Models\Subscription;
use App\Models\TrialClaim;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use LogicException;

class AuthenticationService
{
    public function __construct(
        private readonly OtpService $otpService,
        private readonly AuthTokenService $tokenService,
    ) {}

    /** @param array<string, mixed> $data */
    public function register(array $data, Request $request): array
    {
        return $this->otpService->consumeVerified(
            $data['otp_challenge_id'],
            OtpPurpose::Registration,
            function (OtpChallenge $challenge) use ($data, $request): array {
                if (User::query()->where('phone_e164', $challenge->phone_e164)->exists()) {
                    throw ValidationException::withMessages([
                        'phone_e164' => ['An account already exists for this phone number.'],
                    ]);
                }

                $phoneHash = $this->phoneIdentifierHash($challenge->phone_e164);

                if (TrialClaim::query()->where('phone_identifier_hash', $phoneHash)->exists()) {
                    throw ValidationException::withMessages([
                        'phone_e164' => ['The demo has already been claimed for this phone number.'],
                    ]);
                }

                $plan = Plan::query()
                    ->where('code', config('authentication.trial.plan_code'))
                    ->where('is_active', true)
                    ->first();

                if (! $plan) {
                    throw new LogicException('The configured trial plan is unavailable.');
                }

                $user = User::create([
                    'name' => $data['name'],
                    'phone_e164' => $challenge->phone_e164,
                    'phone_verified_at' => now(),
                    'password' => $data['password'],
                    'preferred_locale' => $data['preferred_locale'],
                    'status' => UserStatus::Active,
                ]);

                $business = Business::create([
                    'name' => $data['business_name'],
                    'slug' => $this->uniqueBusinessSlug($data['business_name']),
                    'phone_e164' => $challenge->phone_e164,
                    'preferred_locale' => $data['preferred_locale'],
                    'created_by_user_id' => $user->id,
                ]);

                BusinessMember::create([
                    'business_id' => $business->id,
                    'user_id' => $user->id,
                    'role' => BusinessRole::Owner,
                    'status' => MembershipStatus::Active,
                    'joined_at' => now(),
                ]);

                $startsAt = now();
                $expiresAt = $startsAt->copy()->addDays($plan->trial_days);
                $subscription = Subscription::create([
                    'business_id' => $business->id,
                    'plan_id' => $plan->id,
                    'source' => SubscriptionSource::Trial,
                    'status' => SubscriptionStatus::Trialing,
                    'starts_at' => $startsAt,
                    'expires_at' => $expiresAt,
                    'offline_grace_until' => $expiresAt->copy()->addDays(
                        (int) config('authentication.trial.offline_grace_days'),
                    ),
                ]);

                $subscription->events()->create([
                    'event' => SubscriptionEventType::Created,
                    'actor_type' => SubscriptionActorType::System,
                    'new_values' => [
                        'status' => SubscriptionStatus::Trialing->value,
                        'plan_code' => $plan->code,
                        'expires_at' => $expiresAt->toIso8601String(),
                    ],
                    'notes' => 'Automatic demo subscription created after phone verification.',
                ]);

                TrialClaim::create([
                    'business_id' => $business->id,
                    'user_id' => $user->id,
                    'phone_identifier_hash' => $phoneHash,
                    'claimed_at' => $startsAt,
                    'expires_at' => $expiresAt,
                ]);

                $device = $this->upsertDevice($user, $data);
                $tokens = $this->tokenService->issue($user, $device, $request);

                return compact('user', 'business', 'subscription', 'tokens');
            },
        );
    }

    /** @param array<string, mixed> $data */
    public function login(array $data, Request $request): array
    {
        return DB::transaction(function () use ($data, $request): array {
            $user = User::query()->where('phone_e164', $data['phone_e164'])->first();

            if (! $user || ! $user->password || ! Hash::check($data['password'], $user->password)) {
                throw ValidationException::withMessages([
                    'phone_e164' => ['The phone number or password is incorrect.'],
                ]);
            }

            if ($user->status !== UserStatus::Active) {
                throw ValidationException::withMessages([
                    'phone_e164' => ['This account is not active. Please contact support.'],
                ]);
            }

            $device = $this->upsertDevice($user, $data);
            $tokens = $this->tokenService->issue($user, $device, $request);

            $user->forceFill([
                'last_login_at' => now(),
                'last_login_ip' => $request->ip(),
            ])->save();

            return compact('user', 'tokens');
        });
    }

    public function resetPassword(string $challengeId, string $resetToken, string $password): void
    {
        $this->otpService->consumeActionToken(
            $challengeId,
            $resetToken,
            OtpPurpose::ForgotPassword,
            function (OtpChallenge $challenge) use ($password): void {
                $user = User::query()->lockForUpdate()->find($challenge->user_id);

                if (! $user) {
                    throw ValidationException::withMessages([
                        'reset_token' => ['The account is no longer available.'],
                    ]);
                }

                $user->forceFill(['password' => $password])->save();
                $this->tokenService->revokeAll($user, 'password_reset');
            },
        );
    }

    /** @param array<string, mixed> $data */
    private function upsertDevice(User $user, array $data): Device
    {
        return Device::query()->updateOrCreate(
            [
                'user_id' => $user->id,
                'installation_uuid' => $data['installation_uuid'],
            ],
            [
                'platform' => 'android',
                'device_name' => $data['device_name'] ?? null,
                'device_model' => $data['device_model'] ?? null,
                'os_version' => $data['os_version'] ?? null,
                'app_version' => $data['app_version'] ?? null,
                'last_seen_at' => now(),
                'revoked_at' => null,
            ],
        );
    }

    private function uniqueBusinessSlug(string $businessName): string
    {
        $base = Str::slug($businessName);
        $base = $base !== '' ? $base : 'tailor-business';

        do {
            $slug = $base.'-'.Str::lower(Str::random(6));
        } while (Business::withTrashed()->where('slug', $slug)->exists());

        return $slug;
    }

    private function phoneIdentifierHash(string $phoneE164): string
    {
        return hash_hmac('sha256', $phoneE164, (string) config('app.key'));
    }
}
