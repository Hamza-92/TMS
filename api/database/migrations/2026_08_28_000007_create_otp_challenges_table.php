<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('otp_challenges', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('phone_e164', 20);
            $table->string('purpose', 40);
            $table->char('code_hash', 64);
            $table->string('provider', 40)->default('log');
            $table->string('status', 32)->default('pending');
            $table->unsignedTinyInteger('attempt_count')->default(0);
            $table->unsignedTinyInteger('max_attempts')->default(5);
            $table->unsignedTinyInteger('resend_count')->default(0);
            $table->dateTime('expires_at');
            $table->dateTime('sent_at')->nullable();
            $table->dateTime('verified_at')->nullable();
            $table->dateTime('consumed_at')->nullable();
            $table->char('action_token_hash', 64)->nullable()->unique();
            $table->dateTime('action_token_expires_at')->nullable();
            $table->uuid('installation_uuid')->nullable();
            $table->string('request_ip', 45)->nullable();
            $table->timestamps();

            $table->index(['phone_e164', 'purpose', 'created_at'], 'otp_phone_purpose_created_index');
            $table->index(['status', 'expires_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('otp_challenges');
    }
};
