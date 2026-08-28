<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscriptions', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('plan_id')->constrained()->restrictOnDelete();
            $table->string('source', 32);
            $table->string('status', 32);
            $table->dateTime('starts_at');
            $table->dateTime('expires_at');
            $table->dateTime('offline_grace_until')->nullable();
            $table->boolean('auto_renew')->default(false);
            $table->string('external_subscription_id', 190)->nullable();
            $table->foreignUlid('activated_by_admin_id')->nullable()->constrained('admin_users')->nullOnDelete();
            $table->dateTime('cancelled_at')->nullable();
            $table->text('cancellation_reason')->nullable();
            $table->timestamps();

            $table->index(['business_id', 'status', 'expires_at']);
            $table->unique(['source', 'external_subscription_id'], 'subscriptions_source_external_unique');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
    }
};
