<?php

namespace App\Http\Requests\Api\V1\Auth;

use Illuminate\Validation\Rules\Password;

class CompleteRegistrationRequest extends DeviceAwareRequest
{
    /** @return array<string, mixed> */
    public function rules(): array
    {
        return array_merge($this->deviceRules(), [
            'otp_challenge_id' => ['required', 'ulid'],
            'otp' => ['required', 'digits:6'],
            'name' => ['required', 'string', 'max:120'],
            'business_name' => ['required', 'string', 'max:160'],
            'preferred_locale' => ['required', 'in:en,ur,ur-Latn'],
            'password' => ['required', 'confirmed', Password::min(8)->letters()->numbers()],
        ]);
    }
}
