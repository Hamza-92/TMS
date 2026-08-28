<?php

namespace App\Models;

use App\Enums\BusinessStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

#[Fillable([
    'name',
    'slug',
    'phone_e164',
    'country_code',
    'currency_code',
    'timezone',
    'preferred_locale',
    'status',
    'created_by_user_id',
    'settings',
    'suspended_at',
    'suspension_reason',
])]
class Business extends Model
{
    use HasUlids, SoftDeletes;

    protected $attributes = [
        'country_code' => 'PK',
        'currency_code' => 'PKR',
        'timezone' => 'Asia/Karachi',
        'preferred_locale' => 'en',
        'status' => 'active',
    ];

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by_user_id');
    }

    public function memberships(): HasMany
    {
        return $this->hasMany(BusinessMember::class);
    }

    public function members(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'business_members')
            ->withPivot(['id', 'role', 'status', 'joined_at'])
            ->withTimestamps();
    }

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function subscriptionPayments(): HasMany
    {
        return $this->hasMany(SubscriptionPayment::class);
    }

    protected function casts(): array
    {
        return [
            'status' => BusinessStatus::class,
            'settings' => 'array',
            'suspended_at' => 'datetime',
        ];
    }
}
