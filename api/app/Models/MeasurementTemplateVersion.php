<?php

namespace App\Models;

use App\Enums\MeasurementUnit;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'measurement_template_id',
    'version_number',
    'name',
    'name_ur',
    'name_roman_ur',
    'category',
    'default_unit',
    'description',
    'created_by_user_id',
])]
class MeasurementTemplateVersion extends Model
{
    use HasUlids;

    public function template(): BelongsTo
    {
        return $this->belongsTo(MeasurementTemplate::class, 'measurement_template_id');
    }

    public function fields(): HasMany
    {
        return $this->hasMany(MeasurementTemplateField::class)
            ->orderBy('section')
            ->orderBy('sort_order')
            ->orderBy('id');
    }

    protected function casts(): array
    {
        return [
            'version_number' => 'integer',
            'default_unit' => MeasurementUnit::class,
        ];
    }
}
