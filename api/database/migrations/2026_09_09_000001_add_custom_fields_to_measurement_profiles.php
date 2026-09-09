<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customer_measurement_profiles', function (Blueprint $table): void {
            $table->json('custom_fields')->nullable()->after('notes');
        });

        Schema::table('customer_measurement_revisions', function (Blueprint $table): void {
            $table->json('custom_fields')->nullable()->after('values');
        });
    }

    public function down(): void
    {
        Schema::table('customer_measurement_revisions', function (Blueprint $table): void {
            $table->dropColumn('custom_fields');
        });

        Schema::table('customer_measurement_profiles', function (Blueprint $table): void {
            $table->dropColumn('custom_fields');
        });
    }
};
