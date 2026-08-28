<?php

namespace App\Models;

use App\Enums\OtpPurpose;
use App\Enums\OtpStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'user_id',
    'phone_e164',
    'purpose',
    'code_hash',
    'provider',
    'status',
    'attempt_count',
    'max_attempts',
    'resend_count',
    'expires_at',
    'sent_at',
    'verified_at',
    'consumed_at',
    'action_token_hash',
    'action_token_expires_at',
    'installation_uuid',
    'request_ip',
])]
#[Hidden(['code_hash', 'action_token_hash'])]
class OtpChallenge extends Model
{
    use HasUlids;

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function messages(): HasMany
    {
        return $this->hasMany(WhatsappMessage::class);
    }

    protected function casts(): array
    {
        return [
            'purpose' => OtpPurpose::class,
            'status' => OtpStatus::class,
            'expires_at' => 'datetime',
            'sent_at' => 'datetime',
            'verified_at' => 'datetime',
            'consumed_at' => 'datetime',
            'action_token_expires_at' => 'datetime',
        ];
    }
}
