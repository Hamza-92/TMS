<?php

namespace App\Http\Requests\Api\V1\Auth;

use Illuminate\Foundation\Http\FormRequest;

abstract class DeviceAwareRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, array<int, string>> */
    protected function deviceRules(): array
    {
        return [
            'installation_uuid' => ['required', 'uuid'],
            'device_name' => ['nullable', 'string', 'max:120'],
            'device_model' => ['nullable', 'string', 'max:120'],
            'os_version' => ['nullable', 'string', 'max:40'],
            'app_version' => ['nullable', 'string', 'max:40'],
        ];
    }

    /** @return array<int, string> */
    protected function phoneRules(): array
    {
        return ['required', 'string', 'regex:/^\+[1-9]\d{7,14}$/'];
    }
}
