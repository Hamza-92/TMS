<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customers', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->uuid('client_uuid');
            $table->string('name', 140);
            $table->string('phone_e164', 20)->nullable();
            $table->string('alternate_phone_e164', 20)->nullable();
            $table->text('address')->nullable();
            $table->text('notes')->nullable();
            $table->string('status', 20)->default('active');
            $table->unsignedBigInteger('version')->default(1);
            $table->foreignUlid('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignUlid('updated_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->dateTime('archived_at')->nullable();
            $table->timestamps();

            $table->unique(['business_id', 'client_uuid']);
            $table->index(['business_id', 'status', 'name']);
            $table->index(['business_id', 'phone_e164']);
            $table->index(['business_id', 'updated_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customers');
    }
};
