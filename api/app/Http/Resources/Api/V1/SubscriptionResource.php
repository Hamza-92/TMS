<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SubscriptionResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'plan_code' => $this->whenLoaded('plan', fn () => $this->plan->code),
            'source' => $this->source->value,
            'status' => $this->status->value,
            'starts_at' => $this->starts_at->toIso8601String(),
            'expires_at' => $this->expires_at->toIso8601String(),
            'offline_grace_until' => $this->offline_grace_until?->toIso8601String(),
        ];
    }
}
