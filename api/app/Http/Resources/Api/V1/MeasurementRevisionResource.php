<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeasurementRevisionResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'client_uuid' => $this->client_uuid,
            'profile_client_uuid' => $this->whenLoaded('profile', fn () => $this->profile->client_uuid),
            'revision_number' => $this->revision_number,
            'template_definition_version' => $this->whenLoaded(
                'templateVersion',
                fn () => $this->templateVersion->version_number,
            ),
            'values' => $this->values,
            'custom_fields' => $this->custom_fields ?? [],
            'notes' => $this->notes,
            'measured_at' => $this->measured_at?->toIso8601String(),
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
