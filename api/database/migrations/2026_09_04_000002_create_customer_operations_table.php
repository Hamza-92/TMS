<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_operations', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('user_id')->nullable()->constrained()->nullOnDelete();
            $table->uuid('operation_uuid');
            $table->uuid('customer_client_uuid');
            $table->string('action', 20);
            $table->char('request_hash', 64);
            $table->unsignedBigInteger('response_version');
            $table->timestamps();

            $table->unique(['business_id', 'operation_uuid']);
            $table->index(['business_id', 'customer_client_uuid']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_operations');
    }
};
