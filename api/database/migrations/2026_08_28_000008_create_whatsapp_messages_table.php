<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('whatsapp_messages', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('otp_challenge_id')->nullable()->constrained()->nullOnDelete();
            $table->string('provider', 40);
            $table->string('provider_message_id', 190)->nullable();
            $table->string('template_name', 120);
            $table->string('recipient_phone_e164', 20);
            $table->string('status', 32)->default('queued');
            $table->string('error_code', 80)->nullable();
            $table->text('error_message')->nullable();
            $table->dateTime('sent_at')->nullable();
            $table->dateTime('delivered_at')->nullable();
            $table->dateTime('read_at')->nullable();
            $table->dateTime('failed_at')->nullable();
            $table->timestamps();

            $table->unique(['provider', 'provider_message_id'], 'whatsapp_provider_message_unique');
            $table->index(['recipient_phone_e164', 'created_at'], 'whatsapp_recipient_created_index');
            $table->index(['status', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('whatsapp_messages');
    }
};
