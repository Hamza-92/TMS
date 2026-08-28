<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('businesses', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->string('name', 160);
            $table->string('slug', 180)->unique();
            $table->string('phone_e164', 20)->nullable();
            $table->char('country_code', 2)->default('PK');
            $table->char('currency_code', 3)->default('PKR');
            $table->string('timezone', 50)->default('Asia/Karachi');
            $table->string('preferred_locale', 10)->default('en');
            $table->string('status', 32)->default('active')->index();
            $table->foreignUlid('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->json('settings')->nullable();
            $table->dateTime('suspended_at')->nullable();
            $table->text('suspension_reason')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('businesses');
    }
};
