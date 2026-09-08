<?php

namespace App\Models;

use App\Enums\MeasurementStatus;
use App\Enums\MeasurementUnit;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

#[Fillable([
    'business_id',
    'customer_id',
    'client_uuid',
    'measurement_template_id',
    'measurement_template_version_id',
    'name',
    'preferred_unit',
    'notes',
    'status',
    'version',
    'latest_revision_number',
    'created_by_user_id',
    'updated_by_user_id',
    'archived_at',
])]
class CustomerMeasurementProfile extends Model
{
    use HasUlids;

    protected $attributes = [
        'preferred_unit' => 'inch',
        'status' => 'active',
        'version' => 1,
        'latest_revision_number' => 0,
    ];

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function template(): BelongsTo
    {
        return $this->belongsTo(MeasurementTemplate::class, 'measurement_template_id');
    }

    public function templateVersion(): BelongsTo
    {
        return $this->belongsTo(MeasurementTemplateVersion::class, 'measurement_template_version_id');
    }

    public function revisions(): HasMany
    {
        return $this->hasMany(CustomerMeasurementRevision::class)
            ->orderByDesc('revision_number');
    }

    public function latestRevision(): HasOne
    {
        return $this->hasOne(CustomerMeasurementRevision::class)
            ->ofMany('revision_number', 'max');
    }

    protected function casts(): array
    {
        return [
            'preferred_unit' => MeasurementUnit::class,
            'status' => MeasurementStatus::class,
            'version' => 'integer',
            'latest_revision_number' => 'integer',
            'archived_at' => 'datetime',
        ];
    }
}
