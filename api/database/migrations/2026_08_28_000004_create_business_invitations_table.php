<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('business_invitations', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->string('phone_e164', 20);
            $table->string('role', 32)->default('staff');
            $table->string('status', 32)->default('pending');
            $table->foreignUlid('invited_by_user_id')->constrained('users')->cascadeOnDelete();
            $table->dateTime('expires_at');
            $table->dateTime('accepted_at')->nullable();
            $table->timestamps();

            $table->index(['business_id', 'phone_e164', 'status'], 'business_invites_lookup_index');
            $table->index(['phone_e164', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('business_invitations');
    }
};
