<?php

use App\Http\Controllers\Admin\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Admin\DashboardController;
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
        Route::get('/tools/otps', OtpViewerController::class)
            ->middleware(['admin.role:superadmin', 'admin.staging-tools'])
            ->name('tools.otps');
        Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
            ->name('logout');
    });
});
