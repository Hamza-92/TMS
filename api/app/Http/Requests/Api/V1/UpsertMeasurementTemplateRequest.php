<?php

namespace App\Http\Requests\Api\V1;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

class UpsertMeasurementTemplateRequest extends FormRequest
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
            'source_template_uuid' => ['nullable', 'uuid'],
            'name' => ['required', 'string', 'min:2', 'max:120'],
            'name_ur' => ['nullable', 'string', 'max:160'],
            'name_roman_ur' => ['nullable', 'string', 'max:160'],
            'category' => ['required', 'string', 'max:80', 'regex:/^[a-z0-9_-]+$/'],
            'default_unit' => ['required', Rule::in(['inch', 'cm'])],
            'description' => ['nullable', 'string', 'max:1000'],
            'fields' => ['required', 'array', 'min:1', 'max:100'],
            'fields.*.client_uuid' => ['required', 'uuid', 'distinct'],
            'fields.*.field_key' => ['required', 'string', 'max:80', 'regex:/^[a-z0-9_-]+$/', 'distinct'],
            'fields.*.label' => ['required', 'string', 'max:120'],
            'fields.*.label_ur' => ['nullable', 'string', 'max:160'],
            'fields.*.label_roman_ur' => ['nullable', 'string', 'max:160'],
            'fields.*.section' => ['required', 'string', 'max:80'],
            'fields.*.value_type' => ['required', Rule::in(['number', 'text'])],
            'fields.*.unit_type' => ['required', Rule::in(['length', 'none'])],
            'fields.*.is_required' => ['required', 'boolean'],
            'fields.*.minimum_value_mm' => ['nullable', 'numeric', 'min:0', 'max:10000'],
            'fields.*.maximum_value_mm' => ['nullable', 'numeric', 'min:0', 'max:10000'],
            'fields.*.sort_order' => ['required', 'integer', 'min:0', 'max:1000'],
            'fields.*.help_text' => ['nullable', 'string', 'max:255'],
            'fields.*.help_text_ur' => ['nullable', 'string', 'max:255'],
            'fields.*.help_text_roman_ur' => ['nullable', 'string', 'max:255'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'name.required' => 'Enter a template name.',
            'category.regex' => 'Use lowercase letters, numbers, hyphens, or underscores for the category.',
            'fields.required' => 'Add at least one measurement field.',
            'fields.min' => 'Add at least one measurement field.',
            'fields.*.client_uuid.distinct' => 'Every measurement field must have a unique identifier.',
            'fields.*.field_key.distinct' => 'Every measurement field must have a unique key.',
        ];
    }

    public function after(): array
    {
        return [function (Validator $validator): void {
            foreach ((array) $this->input('fields', []) as $index => $field) {
                if (($field['value_type'] ?? null) === 'text' && ($field['unit_type'] ?? null) !== 'none') {
                    $validator->errors()->add("fields.{$index}.unit_type", 'Text fields cannot use a length unit.');
                }

                $minimum = $field['minimum_value_mm'] ?? null;
                $maximum = $field['maximum_value_mm'] ?? null;
                if ($minimum !== null && $maximum !== null && (float) $maximum < (float) $minimum) {
                    $validator->errors()->add(
                        "fields.{$index}.maximum_value_mm",
                        'The maximum value must be greater than or equal to the minimum value.',
                    );
                }
            }
        }];
    }

    protected function prepareForValidation(): void
    {
        $data = $this->all();
        foreach (['name', 'name_ur', 'name_roman_ur', 'category', 'description'] as $field) {
            if (array_key_exists($field, $data)) {
                $value = trim((string) $data[$field]);
                $data[$field] = $value === '' ? null : $value;
            }
        }

        $data['category'] = isset($data['category']) ? mb_strtolower((string) $data['category']) : null;
        $data['fields'] = array_map(function (mixed $field): mixed {
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
        }, (array) ($data['fields'] ?? []));

        $this->replace($data);
    }
}
