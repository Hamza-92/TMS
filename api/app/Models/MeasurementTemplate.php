<?php

namespace App\Models;

use App\Enums\MeasurementStatus;
use App\Enums\MeasurementTemplateSource;
use App\Enums\MeasurementUnit;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

#[Fillable([
    'business_id',
    'client_uuid',
    'system_code',
    'source',
    'source_template_id',
    'name',
    'name_ur',
    'name_roman_ur',
    'category',
    'default_unit',
    'description',
    'status',
    'version',
    'current_definition_version',
    'created_by_user_id',
    'updated_by_user_id',
    'archived_at',
])]
class MeasurementTemplate extends Model
{
    use HasUlids;

    protected $attributes = [
        'source' => 'business',
        'default_unit' => 'inch',
        'status' => 'active',
        'version' => 1,
        'current_definition_version' => 1,
    ];

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function sourceTemplate(): BelongsTo
    {
        return $this->belongsTo(self::class, 'source_template_id');
    }

    public function versions(): HasMany
    {
        return $this->hasMany(MeasurementTemplateVersion::class);
    }

    public function currentDefinition(): HasOne
    {
        return $this->hasOne(MeasurementTemplateVersion::class)
            ->ofMany('version_number', 'max');
    }

    protected function casts(): array
    {
        return [
            'source' => MeasurementTemplateSource::class,
            'default_unit' => MeasurementUnit::class,
            'status' => MeasurementStatus::class,
            'version' => 'integer',
            'current_definition_version' => 'integer',
            'archived_at' => 'datetime',
        ];
    }
}
