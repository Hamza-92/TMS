<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'phone_e164' => $this->phone_e164,
            'phone_verified_at' => $this->phone_verified_at?->toIso8601String(),
            'email' => $this->email,
            'preferred_locale' => $this->preferred_locale,
            'status' => $this->status->value,
        ];
    }
}
