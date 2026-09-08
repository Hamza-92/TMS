<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeasurementProfileResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'client_uuid' => $this->client_uuid,
            'business_id' => $this->business_id,
            'customer_client_uuid' => $this->whenLoaded('customer', fn () => $this->customer->client_uuid),
            'template' => $this->whenLoaded('template', fn (): array => [
                'client_uuid' => $this->template->client_uuid,
                'name' => $this->template->name,
                'name_ur' => $this->template->name_ur,
                'name_roman_ur' => $this->template->name_roman_ur,
                'category' => $this->template->category,
            ]),
            'template_definition_version' => $this->whenLoaded(
                'templateVersion',
                fn () => $this->templateVersion->version_number,
            ),
            'name' => $this->name,
            'preferred_unit' => $this->preferred_unit->value,
            'notes' => $this->notes,
            'status' => $this->status->value,
            'version' => $this->version,
            'latest_revision_number' => $this->latest_revision_number,
            'latest_revision' => $this->whenLoaded(
                'latestRevision',
                fn () => $this->latestRevision
                    ? MeasurementRevisionResource::make($this->latestRevision)->resolve($request)
                    : null,
            ),
            'archived_at' => $this->archived_at?->toIso8601String(),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
