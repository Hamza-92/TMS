<?php

namespace App\Models;

use App\Enums\BillingPeriod;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'code',
    'name',
    'description',
    'billing_period',
    'price',
    'currency_code',
    'trial_days',
    'features',
    'limits',
    'is_active',
    'sort_order',
])]
class Plan extends Model
{
    use HasUlids;

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function payments(): HasMany
    {
        return $this->hasMany(SubscriptionPayment::class);
    }

    protected function casts(): array
    {
        return [
            'billing_period' => BillingPeriod::class,
            'price' => 'decimal:2',
            'features' => 'array',
            'limits' => 'array',
            'is_active' => 'boolean',
        ];
    }
}
