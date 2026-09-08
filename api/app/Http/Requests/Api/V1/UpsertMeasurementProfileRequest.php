<?php

namespace App\Http\Requests\Api\V1;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpsertMeasurementProfileRequest extends FormRequest
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
            'template_client_uuid' => ['required', 'uuid'],
            'template_definition_version' => ['required', 'integer', 'min:1'],
            'name' => ['required', 'string', 'min:2', 'max:120'],
            'preferred_unit' => ['required', Rule::in(['inch', 'cm'])],
            'notes' => ['nullable', 'string', 'max:2000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'name.required' => 'Enter a measurement profile name.',
            'template_client_uuid.required' => 'Select a measurement template.',
            'template_definition_version.required' => 'Select a template version.',
        ];
    }

    protected function prepareForValidation(): void
    {
        foreach (['name', 'notes'] as $field) {
            if ($this->has($field)) {
                $value = trim((string) $this->input($field));
                $this->merge([$field => $value === '' ? null : $value]);
            }
        }
    }
}
