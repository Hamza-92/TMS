<?php

namespace App\Http\Resources\Api\V1;

use App\Models\MeasurementTemplateField;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeasurementTemplateVersionResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'template_client_uuid' => $this->whenLoaded('template', fn () => $this->template->client_uuid),
            'version_number' => $this->version_number,
            'name' => $this->name,
            'name_ur' => $this->name_ur,
            'name_roman_ur' => $this->name_roman_ur,
            'category' => $this->category,
            'default_unit' => $this->default_unit->value,
            'description' => $this->description,
            'fields' => $this->whenLoaded('fields', fn () => $this->fields
                ->map(fn (MeasurementTemplateField $field): array => [
                    'client_uuid' => $field->client_uuid,
                    'field_key' => $field->field_key,
                    'label' => $field->label,
                    'label_ur' => $field->label_ur,
                    'label_roman_ur' => $field->label_roman_ur,
                    'section' => $field->section,
                    'value_type' => $field->value_type,
                    'unit_type' => $field->unit_type,
                    'is_required' => $field->is_required,
                    'minimum_value_mm' => $field->minimum_value_mm,
                    'maximum_value_mm' => $field->maximum_value_mm,
                    'sort_order' => $field->sort_order,
                    'help_text' => $field->help_text,
                    'help_text_ur' => $field->help_text_ur,
                    'help_text_roman_ur' => $field->help_text_roman_ur,
                ])->values()->all()),
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
