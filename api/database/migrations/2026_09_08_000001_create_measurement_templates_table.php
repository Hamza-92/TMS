<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('measurement_templates', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->nullable()->constrained()->cascadeOnDelete();
            $table->uuid('client_uuid')->unique();
            $table->string('system_code', 80)->nullable()->unique();
            $table->string('source', 20);
            $table->foreignUlid('source_template_id')->nullable()
                ->constrained('measurement_templates')->nullOnDelete();
            $table->string('name', 120);
            $table->string('name_ur', 160)->nullable();
            $table->string('name_roman_ur', 160)->nullable();
            $table->string('category', 80);
            $table->string('default_unit', 12)->default('inch');
            $table->text('description')->nullable();
            $table->string('status', 20)->default('active');
            $table->unsignedBigInteger('version')->default(1);
            $table->unsignedInteger('current_definition_version')->default(1);
            $table->foreignUlid('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignUlid('updated_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->dateTime('archived_at')->nullable();
            $table->timestamps();

            $table->index(['business_id', 'status', 'name']);
            $table->index(['source', 'status', 'category']);
            $table->index(['business_id', 'updated_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('measurement_templates');
    }
};
