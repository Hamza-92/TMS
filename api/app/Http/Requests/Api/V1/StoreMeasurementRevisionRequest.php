<?php

namespace App\Http\Requests\Api\V1;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreMeasurementRevisionRequest extends FormRequest
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
            'base_version' => ['required', 'integer', 'min:1'],
            'revision_client_uuid' => ['required', 'uuid'],
            'measured_at' => ['required', 'date'],
            'notes' => ['nullable', 'string', 'max:2000'],
            'values' => ['required', 'array', 'min:1', 'max:100'],
            'values.*.field_uuid' => ['required', 'uuid', 'distinct'],
            'values.*.value' => ['required'],
            'values.*.unit' => ['nullable', Rule::in(['inch', 'cm'])],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'values.required' => 'Enter at least one measurement.',
            'values.min' => 'Enter at least one measurement.',
            'values.*.field_uuid.distinct' => 'Each measurement field may be entered only once.',
        ];
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('notes')) {
            $notes = trim((string) $this->input('notes'));
            $this->merge(['notes' => $notes === '' ? null : $notes]);
        }
    }
}
