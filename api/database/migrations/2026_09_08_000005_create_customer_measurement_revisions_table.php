<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_measurement_revisions', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('customer_measurement_profile_id');
            $table->foreign('customer_measurement_profile_id', 'cm_revisions_profile_fk')
                ->references('id')->on('customer_measurement_profiles')->cascadeOnDelete();
            $table->uuid('client_uuid');
            $table->unsignedInteger('revision_number');
            $table->foreignUlid('measurement_template_version_id');
            $table->foreign('measurement_template_version_id', 'cm_revisions_version_fk')
                ->references('id')->on('measurement_template_versions')->restrictOnDelete();
            $table->json('values');
            $table->text('notes')->nullable();
            $table->dateTime('measured_at');
            $table->foreignUlid('created_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->unique(['business_id', 'client_uuid'], 'cm_revisions_business_uuid_unique');
            $table->unique(['customer_measurement_profile_id', 'revision_number'], 'measurement_profile_revision_unique');
            $table->index(['business_id', 'updated_at'], 'cm_revisions_updated_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_measurement_revisions');
    }
};
