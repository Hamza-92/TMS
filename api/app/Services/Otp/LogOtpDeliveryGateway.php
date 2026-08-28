<?php

namespace App\Services\Otp;

use App\Contracts\OtpDeliveryGateway;
use App\Enums\WhatsAppMessageStatus;
use App\Models\OtpChallenge;
use Illuminate\Support\Facades\Log;

class LogOtpDeliveryGateway implements OtpDeliveryGateway
{
    public function send(OtpChallenge $challenge, string $plainCode): void
    {
        Log::info('Local authentication OTP', [
            'challenge_id' => $challenge->id,
            'phone_e164' => $challenge->phone_e164,
            'purpose' => $challenge->purpose->value,
            'code' => $plainCode,
        ]);

        $challenge->messages()->create([
            'provider' => 'log',
            'template_name' => 'authentication_otp',
            'recipient_phone_e164' => $challenge->phone_e164,
            'status' => WhatsAppMessageStatus::Sent,
            'sent_at' => now(),
        ]);

        $challenge->forceFill(['sent_at' => now()])->save();
    }
}
