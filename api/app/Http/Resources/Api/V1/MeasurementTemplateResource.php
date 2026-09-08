<?php

namespace App\Http\Resources\Api\V1;

use App\Models\MeasurementTemplateField;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeasurementTemplateResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        $definition = $this->resource->relationLoaded('currentDefinition')
            ? $this->currentDefinition
            : null;

        return [
            'id' => $this->id,
            'client_uuid' => $this->client_uuid,
            'business_id' => $this->business_id,
            'system_code' => $this->system_code,
            'source' => $this->source->value,
            'source_template_uuid' => $this->whenLoaded(
                'sourceTemplate',
                fn () => $this->sourceTemplate?->client_uuid,
            ),
            'name' => $this->name,
            'name_ur' => $this->name_ur,
            'name_roman_ur' => $this->name_roman_ur,
            'category' => $this->category,
            'default_unit' => $this->default_unit->value,
            'description' => $this->description,
            'status' => $this->status->value,
            'version' => $this->version,
            'current_definition_version' => $this->current_definition_version,
            'fields' => $definition && $definition->relationLoaded('fields')
                ? $definition->fields->map(fn (MeasurementTemplateField $field): array => [
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
                ])->values()->all()
                : [],
            'archived_at' => $this->archived_at?->toIso8601String(),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
