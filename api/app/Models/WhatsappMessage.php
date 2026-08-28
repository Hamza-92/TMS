<?php

namespace App\Models;

use App\Enums\WhatsAppMessageStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'otp_challenge_id',
    'provider',
    'provider_message_id',
    'template_name',
    'recipient_phone_e164',
    'status',
    'error_code',
    'error_message',
    'sent_at',
    'delivered_at',
    'read_at',
    'failed_at',
])]
class WhatsappMessage extends Model
{
    use HasUlids;

    protected $table = 'whatsapp_messages';

    public function otpChallenge(): BelongsTo
    {
        return $this->belongsTo(OtpChallenge::class);
    }

    protected function casts(): array
    {
        return [
            'status' => WhatsAppMessageStatus::class,
            'sent_at' => 'datetime',
            'delivered_at' => 'datetime',
            'read_at' => 'datetime',
            'failed_at' => 'datetime',
        ];
    }
}
