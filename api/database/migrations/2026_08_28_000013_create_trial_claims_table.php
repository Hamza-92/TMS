<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('trial_claims', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('user_id')->constrained()->cascadeOnDelete();
            $table->char('phone_identifier_hash', 64)->unique();
            $table->dateTime('claimed_at');
            $table->dateTime('expires_at');
            $table->timestamps();

            $table->index(['business_id', 'expires_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('trial_claims');
    }
};
