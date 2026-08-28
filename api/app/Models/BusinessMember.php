<?php

namespace App\Models;

use App\Enums\BusinessRole;
use App\Enums\MembershipStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'business_id',
    'user_id',
    'role',
    'status',
    'invited_by_user_id',
    'joined_at',
])]
class BusinessMember extends Model
{
    use HasUlids;

    public function business(): BelongsTo
    {
        return $this->belongsTo(Business::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function inviter(): BelongsTo
    {
        return $this->belongsTo(User::class, 'invited_by_user_id');
    }

    protected function casts(): array
    {
        return [
            'role' => BusinessRole::class,
            'status' => MembershipStatus::class,
            'joined_at' => 'datetime',
        ];
    }
}
