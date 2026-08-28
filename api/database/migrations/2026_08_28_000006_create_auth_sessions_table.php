<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('auth_sessions', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('user_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('device_id')->constrained()->cascadeOnDelete();
            $table->char('access_token_hash', 64)->unique();
            $table->char('refresh_token_hash', 64)->unique();
            $table->dateTime('access_expires_at');
            $table->dateTime('refresh_expires_at');
            $table->dateTime('last_used_at')->nullable();
            $table->dateTime('last_refreshed_at')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->dateTime('revoked_at')->nullable();
            $table->string('revocation_reason')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'revoked_at']);
            $table->index(['device_id', 'revoked_at']);
            $table->index('refresh_expires_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('auth_sessions');
    }
};
