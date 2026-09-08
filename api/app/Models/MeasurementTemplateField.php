<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'measurement_template_version_id',
    'client_uuid',
    'field_key',
    'label',
    'label_ur',
    'label_roman_ur',
    'section',
    'value_type',
    'unit_type',
    'is_required',
    'minimum_value_mm',
    'maximum_value_mm',
    'sort_order',
    'help_text',
    'help_text_ur',
    'help_text_roman_ur',
])]
class MeasurementTemplateField extends Model
{
    use HasUlids;

    public function templateVersion(): BelongsTo
    {
        return $this->belongsTo(MeasurementTemplateVersion::class, 'measurement_template_version_id');
    }

    protected function casts(): array
    {
        return [
            'is_required' => 'boolean',
            'minimum_value_mm' => 'decimal:2',
            'maximum_value_mm' => 'decimal:2',
            'sort_order' => 'integer',
        ];
    }
}
