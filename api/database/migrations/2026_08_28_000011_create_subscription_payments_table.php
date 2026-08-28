<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscription_payments', function (Blueprint $table): void {
            $table->ulid('id')->primary();
            $table->foreignUlid('business_id')->constrained()->cascadeOnDelete();
            $table->foreignUlid('subscription_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignUlid('plan_id')->constrained()->restrictOnDelete();
            $table->string('method', 32);
            $table->decimal('amount', 12, 2);
            $table->char('currency_code', 3)->default('PKR');
            $table->string('transaction_reference', 190)->nullable();
            $table->text('receipt_path')->nullable();
            $table->string('status', 32)->default('pending');
            $table->foreignUlid('submitted_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignUlid('verified_by_admin_id')->nullable()->constrained('admin_users')->nullOnDelete();
            $table->dateTime('paid_at')->nullable();
            $table->dateTime('submitted_at')->nullable();
            $table->dateTime('verified_at')->nullable();
            $table->dateTime('rejected_at')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->text('admin_notes')->nullable();
            $table->timestamps();

            $table->unique(['method', 'transaction_reference'], 'subscription_payment_reference_unique');
            $table->index(['business_id', 'status', 'created_at'], 'subscription_payment_business_status_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subscription_payments');
    }
};
