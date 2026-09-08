<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('measurement_operations', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('user_id')->nullable()->constrained()->nullOnDelete();
            $table->uuid('operation_uuid');
            $table->string('entity_type', 30);
            $table->uuid('entity_client_uuid');
            $table->string('action', 30);
            $table->char('request_hash', 64);
            $table->unsignedBigInteger('response_version');
            $table->timestamps();

            $table->unique(['business_id', 'operation_uuid']);
            $table->index(['business_id', 'entity_type', 'entity_client_uuid'], 'measurement_operation_entity_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('measurement_operations');
    }
};
