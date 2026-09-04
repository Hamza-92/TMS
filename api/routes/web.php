<?php

use App\Http\Controllers\Admin\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Admin\BusinessController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\PaymentController;
use App\Http\Controllers\Admin\PlanController;
use App\Http\Controllers\Admin\Tools\OtpViewerController;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin');

Route::prefix('admin')->name('admin.')->group(function (): void {
    Route::middleware('guest:admin')->group(function (): void {
        Route::get('/login', [AuthenticatedSessionController::class, 'create'])
            ->name('login');
        Route::post('/login', [AuthenticatedSessionController::class, 'store'])
            ->middleware('throttle:admin-login')
            ->name('login.store');
    });

    Route::middleware(['auth:admin', 'admin.active'])->group(function (): void {
        Route::get('/', DashboardController::class)->name('dashboard');
        Route::get('/businesses', [BusinessController::class, 'index'])
            ->name('businesses.index');
        Route::get('/businesses/{business}', [BusinessController::class, 'show'])
            ->name('businesses.show');
        Route::post('/businesses/{business}/suspend', [BusinessController::class, 'suspend'])
            ->middleware('admin.role:superadmin')
            ->name('businesses.suspend');
        Route::post('/businesses/{business}/reactivate', [BusinessController::class, 'reactivate'])
            ->middleware('admin.role:superadmin')
            ->name('businesses.reactivate');
        Route::get('/plans', [PlanController::class, 'index'])
            ->name('plans.index');
        Route::post('/plans', [PlanController::class, 'store'])
            ->middleware('admin.role:superadmin')
            ->name('plans.store');
        Route::put('/plans/{plan}', [PlanController::class, 'update'])
            ->middleware('admin.role:superadmin')
            ->name('plans.update');
        Route::post('/plans/{plan}/toggle', [PlanController::class, 'toggle'])
            ->middleware('admin.role:superadmin')
            ->name('plans.toggle');
        Route::get('/payments', [PaymentController::class, 'index'])
            ->name('payments.index');
        Route::get('/payments/{payment}', [PaymentController::class, 'show'])
            ->name('payments.show');
        Route::post('/payments/{payment}/approve', [PaymentController::class, 'approve'])
            ->middleware('admin.role:superadmin,finance')
            ->name('payments.approve');
        Route::post('/payments/{payment}/reject', [PaymentController::class, 'reject'])
            ->middleware('admin.role:superadmin,finance')
            ->name('payments.reject');
        Route::get('/tools/otps', OtpViewerController::class)
            ->middleware(['admin.role:superadmin', 'admin.staging-tools'])
            ->name('tools.otps');
        Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
            ->name('logout');
    });
});
