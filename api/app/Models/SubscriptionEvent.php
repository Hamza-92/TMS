<?php

namespace App\Models;

use App\Enums\SubscriptionActorType;
use App\Enums\SubscriptionEventType;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'subscription_id',
    'event',
    'actor_type',
    'actor_id',
    'previous_values',
    'new_values',
    'notes',
])]
class SubscriptionEvent extends Model
{
    use HasUlids;

    public const UPDATED_AT = null;

    public function subscription(): BelongsTo
    {
        return $this->belongsTo(Subscription::class);
    }

    protected function casts(): array
    {
        return [
            'event' => SubscriptionEventType::class,
            'actor_type' => SubscriptionActorType::class,
            'previous_values' => 'array',
            'new_values' => 'array',
        ];
    }
}
