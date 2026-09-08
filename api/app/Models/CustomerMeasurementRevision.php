<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'business_id',
    'customer_measurement_profile_id',
    'client_uuid',
    'revision_number',
    'measurement_template_version_id',
    'values',
    'notes',
    'measured_at',
    'created_by_user_id',
])]
class CustomerMeasurementRevision extends Model
{
    use HasUlids;

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function profile(): BelongsTo
    {
        return $this->belongsTo(CustomerMeasurementProfile::class, 'customer_measurement_profile_id');
    }

    public function templateVersion(): BelongsTo
    {
        return $this->belongsTo(MeasurementTemplateVersion::class, 'measurement_template_version_id');
    }

    protected function casts(): array
    {
        return [
            'revision_number' => 'integer',
            'values' => 'array',
            'measured_at' => 'datetime',
        ];
    }
}
