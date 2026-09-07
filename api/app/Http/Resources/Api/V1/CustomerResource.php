<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class CustomerResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'client_uuid' => $this->client_uuid,
            'business_id' => $this->business_id,
            'name' => $this->name,
            'phone_e164' => $this->phone_e164,
            'alternate_phone_e164' => $this->alternate_phone_e164,
            'address' => $this->address,
            'notes' => $this->notes,
            'photo_url' => $this->photo_path
                ? $request->getSchemeAndHttpHost().Storage::disk('public')->url($this->photo_path)
                : null,
            'status' => $this->status->value,
            'version' => $this->version,
            'archived_at' => $this->archived_at?->toIso8601String(),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
