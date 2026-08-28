<?php

namespace App\Http\Requests\Api\V1\Auth;

class LoginRequest extends DeviceAwareRequest
{
    /** @return array<string, mixed> */
    public function rules(): array
    {
        return array_merge($this->deviceRules(), [
            'phone_e164' => $this->phoneRules(),
            'password' => ['required', 'string'],
        ]);
    }
}
