<?php

namespace App\Models;

use App\Enums\CustomerStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'business_id',
    'client_uuid',
    'name',
    'phone_e164',
    'alternate_phone_e164',
    'address',
    'notes',
    'photo_path',
    'status',
    'version',
    'created_by_user_id',
    'updated_by_user_id',
    'archived_at',
])]
class Customer extends Model
{
    use HasUlids;

    protected $attributes = [
        'status' => 'active',
        'version' => 1,
    ];

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by_user_id');
    }

    public function updater(): BelongsTo
    {
        return $this->belongsTo(User::class, 'updated_by_user_id');
    }

    public function operations(): HasMany
    {
        return $this->hasMany(CustomerOperation::class, 'customer_client_uuid', 'client_uuid');
    }

    public function measurementProfiles(): HasMany
    {
        return $this->hasMany(CustomerMeasurementProfile::class);
    }

    protected function casts(): array
    {
        return [
            'status' => CustomerStatus::class,
            'version' => 'integer',
            'archived_at' => 'datetime',
        ];
    }
}
