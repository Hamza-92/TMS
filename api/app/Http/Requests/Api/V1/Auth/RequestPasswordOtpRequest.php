<?php

namespace App\Http\Requests\Api\V1\Auth;

class RequestPasswordOtpRequest extends DeviceAwareRequest
{
    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'phone_e164' => $this->phoneRules(),
            'installation_uuid' => ['required', 'uuid'],
        ];
    }
}
