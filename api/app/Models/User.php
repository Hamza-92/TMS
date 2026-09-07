<?php

namespace App\Models;

use App\Enums\UserStatus;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

#[Fillable([
    'name',
    'phone_e164',
    'phone_verified_at',
    'email',
    'email_verified_at',
    'password',
    'preferred_locale',
    'status',
    'last_login_at',
    'last_login_ip',
])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, HasUlids, Notifiable, SoftDeletes;

    public function businessMemberships(): HasMany
    {
        return $this->hasMany(BusinessMember::class);
    }

    public function businesses(): BelongsToMany
    {
        return $this->belongsToMany(Business::class, 'business_members')
            ->withPivot(['id', 'role', 'status', 'joined_at'])
            ->withTimestamps();
    }

    public function devices(): HasMany
    {
        return $this->hasMany(Device::class);
    }

    public function authSessions(): HasMany
    {
        return $this->hasMany(AuthSession::class);
    }

    public function otpChallenges(): HasMany
    {
        return $this->hasMany(OtpChallenge::class);
    }

    public function createdCustomers(): HasMany
    {
        return $this->hasMany(Customer::class, 'created_by_user_id');
    }

    public function updatedCustomers(): HasMany
    {
        return $this->hasMany(Customer::class, 'updated_by_user_id');
    }

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'phone_verified_at' => 'datetime',
            'email_verified_at' => 'datetime',
            'last_login_at' => 'datetime',
            'password' => 'hashed',
            'status' => UserStatus::class,
        ];
    }
}
