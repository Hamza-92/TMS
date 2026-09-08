<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('measurement_template_versions', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('measurement_template_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('version_number');
            $table->string('name', 120);
            $table->string('name_ur', 160)->nullable();
            $table->string('name_roman_ur', 160)->nullable();
            $table->string('category', 80);
            $table->string('default_unit', 12);
            $table->text('description')->nullable();
            $table->foreignUlid('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->unique(['measurement_template_id', 'version_number'], 'measurement_template_version_unique');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('measurement_template_versions');
    }
};
