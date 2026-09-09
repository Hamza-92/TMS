<?php

namespace App\Http\Requests\Api\V1;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

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
            'custom_fields' => ['sometimes', 'array', 'max:30'],
            'custom_fields.*.client_uuid' => ['required', 'uuid', 'distinct'],
            'custom_fields.*.field_key' => ['required', 'string', 'max:80', 'regex:/^[a-z0-9_-]+$/', 'distinct'],
            'custom_fields.*.label' => ['required', 'string', 'max:120'],
            'custom_fields.*.label_ur' => ['nullable', 'string', 'max:160'],
            'custom_fields.*.label_roman_ur' => ['nullable', 'string', 'max:160'],
            'custom_fields.*.section' => ['required', 'string', 'max:80'],
            'custom_fields.*.value_type' => ['required', Rule::in(['number', 'text'])],
            'custom_fields.*.unit_type' => ['required', Rule::in(['length', 'none'])],
            'custom_fields.*.is_required' => ['required', 'boolean'],
            'custom_fields.*.minimum_value_mm' => ['nullable', 'numeric', 'min:0', 'max:10000'],
            'custom_fields.*.maximum_value_mm' => ['nullable', 'numeric', 'min:0', 'max:10000'],
            'custom_fields.*.sort_order' => ['required', 'integer', 'min:0', 'max:1000'],
            'custom_fields.*.help_text' => ['nullable', 'string', 'max:255'],
            'custom_fields.*.help_text_ur' => ['nullable', 'string', 'max:255'],
            'custom_fields.*.help_text_roman_ur' => ['nullable', 'string', 'max:255'],
        ];
    }

    public function after(): array
    {
        return [function (Validator $validator): void {
            foreach ((array) $this->input('custom_fields', []) as $index => $field) {
                if (($field['value_type'] ?? null) === 'text' && ($field['unit_type'] ?? null) !== 'none') {
                    $validator->errors()->add("custom_fields.{$index}.unit_type", 'Text fields cannot use a length unit.');
                }

                $minimum = $field['minimum_value_mm'] ?? null;
                $maximum = $field['maximum_value_mm'] ?? null;
                if ($minimum !== null && $maximum !== null && (float) $maximum < (float) $minimum) {
                    $validator->errors()->add(
                        "custom_fields.{$index}.maximum_value_mm",
                        'The maximum value must be greater than or equal to the minimum value.',
                    );
                }
            }
        }];
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

        if (! $this->has('custom_fields')) {
            return;
        }

        $customFields = array_map(function (mixed $field): mixed {
            if (! is_array($field)) {
                return $field;
            }

            foreach ([
                'field_key', 'label', 'label_ur', 'label_roman_ur', 'section',
                'help_text', 'help_text_ur', 'help_text_roman_ur',
            ] as $key) {
                if (array_key_exists($key, $field)) {
                    $value = trim((string) $field[$key]);
                    $field[$key] = $value === '' ? null : $value;
                }
            }

            if (isset($field['field_key'])) {
                $field['field_key'] = mb_strtolower((string) $field['field_key']);
            }

            return $field;
        }, (array) $this->input('custom_fields', []));
        $this->merge(['custom_fields' => $customFields]);
    }
}
