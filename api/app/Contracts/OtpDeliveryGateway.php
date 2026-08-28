<?php

namespace App\Contracts;

use App\Models\OtpChallenge;

interface OtpDeliveryGateway
{
    public function send(OtpChallenge $challenge, string $plainCode): void;
}
