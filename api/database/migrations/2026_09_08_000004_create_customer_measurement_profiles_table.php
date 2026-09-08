<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_measurement_profiles', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('customer_id')->constrained()->cascadeOnDelete();
            $table->uuid('client_uuid');
            $table->foreignUlid('measurement_template_id');
            $table->foreign('measurement_template_id', 'cm_profiles_template_fk')
                ->references('id')->on('measurement_templates')->restrictOnDelete();
            $table->foreignUlid('measurement_template_version_id');
            $table->foreign('measurement_template_version_id', 'cm_profiles_version_fk')
                ->references('id')->on('measurement_template_versions')->restrictOnDelete();
            $table->string('name', 120);
            $table->string('preferred_unit', 12)->default('inch');
            $table->text('notes')->nullable();
            $table->string('status', 20)->default('active');
            $table->unsignedBigInteger('version')->default(1);
            $table->unsignedInteger('latest_revision_number')->default(0);
            $table->foreignUlid('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignUlid('updated_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->dateTime('archived_at')->nullable();
            $table->timestamps();

            $table->unique(['business_id', 'client_uuid'], 'cm_profiles_business_uuid_unique');
            $table->index(['customer_id', 'status', 'name']);
            $table->index(['business_id', 'updated_at'], 'cm_profiles_updated_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_measurement_profiles');
    }
};
