<?php

namespace App\Services\Otp;

use App\Models\OtpChallenge;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;

class StagingOtpVault
{
    public function enabled(): bool
    {
        return (bool) config('admin.staging_tools_enabled')
            && app()->environment(['local', 'testing', 'staging'])
            && config('authentication.otp.driver') === 'log';
    }

    public function store(OtpChallenge $challenge, string $plainCode): void
    {
        if (! $this->enabled()) {
            return;
        }

        Cache::put(
            $this->key($challenge->id),
            Crypt::encryptString($plainCode),
            $challenge->expires_at,
        );
    }

    public function reveal(OtpChallenge $challenge): ?string
    {
        if (
            ! $this->enabled()
            || $challenge->expires_at->isPast()
            || $challenge->status->value !== 'pending'
        ) {
            return null;
        }

        $encryptedCode = Cache::get($this->key($challenge->id));

        if (! is_string($encryptedCode)) {
            return null;
        }

        try {
            return Crypt::decryptString($encryptedCode);
        } catch (DecryptException) {
            Cache::forget($this->key($challenge->id));

            return null;
        }
    }

    public function forget(string $challengeId): void
    {
        Cache::forget($this->key($challengeId));
    }

    public function cacheKey(string $challengeId): string
    {
        return $this->key($challengeId);
    }

    private function key(string $challengeId): string
    {
        return "admin:staging-otp:{$challengeId}";
    }
}
