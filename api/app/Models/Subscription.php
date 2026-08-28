<?php

namespace App\Models;

use App\Enums\SubscriptionSource;
use App\Enums\SubscriptionStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'business_id',
    'plan_id',
    'source',
    'status',
    'starts_at',
    'expires_at',
    'offline_grace_until',
    'auto_renew',
    'external_subscription_id',
    'activated_by_admin_id',
    'cancelled_at',
    'cancellation_reason',
])]
class Subscription extends Model
{
    use HasUlids;

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function activatedBy(): BelongsTo
    {
        return $this->belongsTo(AdminUser::class, 'activated_by_admin_id');
    }

    public function payments(): HasMany
    {
        return $this->hasMany(SubscriptionPayment::class);
    }

    public function events(): HasMany
    {
        return $this->hasMany(SubscriptionEvent::class);
    }

    protected function casts(): array
    {
        return [
            'source' => SubscriptionSource::class,
            'status' => SubscriptionStatus::class,
            'starts_at' => 'datetime',
            'expires_at' => 'datetime',
            'offline_grace_until' => 'datetime',
            'auto_renew' => 'boolean',
            'cancelled_at' => 'datetime',
        ];
    }
}
