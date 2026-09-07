<?php

namespace App\Http\Requests\Api\V1;

use Illuminate\Foundation\Http\FormRequest;

class UpsertCustomerRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'operation_uuid' => ['required', 'uuid'],
            'base_version' => ['required', 'integer', 'min:0'],
            'name' => ['required', 'string', 'min:2', 'max:140'],
            'phone_e164' => ['nullable', 'regex:/^\+[1-9]\d{7,14}$/'],
            'alternate_phone_e164' => ['nullable', 'different:phone_e164', 'regex:/^\+[1-9]\d{7,14}$/'],
            'address' => ['nullable', 'string', 'max:1000'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'name.required' => 'Enter the customer name.',
            'name.min' => 'Customer name must contain at least 2 characters.',
            'phone_e164.regex' => 'Enter the phone number with its country code, for example +923001234567.',
            'alternate_phone_e164.regex' => 'Enter the alternate phone number with its country code.',
            'alternate_phone_e164.different' => 'The alternate phone number must be different.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $values = [];

        foreach (['name', 'phone_e164', 'alternate_phone_e164', 'address', 'notes'] as $field) {
            if (! $this->has($field)) {
                continue;
            }

            $value = trim((string) $this->input($field));
            $values[$field] = $value === '' ? null : $value;
        }

        $this->merge($values);
    }
}
