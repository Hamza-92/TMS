<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('measurement_template_fields', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('measurement_template_version_id');
            $table->foreign('measurement_template_version_id', 'mt_fields_version_fk')
                ->references('id')->on('measurement_template_versions')->cascadeOnDelete();
            $table->uuid('client_uuid');
            $table->string('field_key', 80);
            $table->string('label', 120);
            $table->string('label_ur', 160)->nullable();
            $table->string('label_roman_ur', 160)->nullable();
            $table->string('section', 80)->default('general');
            $table->string('value_type', 20)->default('number');
            $table->string('unit_type', 20)->default('length');
            $table->boolean('is_required')->default(false);
            $table->decimal('minimum_value_mm', 10, 2)->nullable();
            $table->decimal('maximum_value_mm', 10, 2)->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->string('help_text', 255)->nullable();
            $table->string('help_text_ur', 255)->nullable();
            $table->string('help_text_roman_ur', 255)->nullable();
            $table->timestamps();

            $table->unique(['measurement_template_version_id', 'client_uuid'], 'measurement_field_uuid_unique');
            $table->unique(['measurement_template_version_id', 'field_key'], 'measurement_field_key_unique');
            $table->index(['measurement_template_version_id', 'section', 'sort_order'], 'measurement_field_order_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('measurement_template_fields');
    }
};
