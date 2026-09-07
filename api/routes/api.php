<?php

use App\Http\Controllers\Api\V1\Auth\AuthController;
use App\Http\Controllers\Api\V1\Auth\PasswordRecoveryController;
use App\Http\Controllers\Api\V1\Auth\SessionController;
use App\Http\Controllers\Api\V1\CustomerController;
use App\Http\Controllers\Api\V1\HealthController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::get('/health', HealthController::class)->name('api.v1.health');

    Route::prefix('auth')->name('api.v1.auth.')->group(function (): void {
        Route::post('/register/request-otp', [AuthController::class, 'requestRegistrationOtp'])
            ->middleware('throttle:auth-otp')
            ->name('register.request-otp');
        Route::post('/register', [AuthController::class, 'completeRegistration'])
            ->name('register');
        Route::post('/login', [AuthController::class, 'login'])
            ->middleware('throttle:auth-login')
            ->name('login');
        Route::post('/token/refresh', [AuthController::class, 'refresh'])
            ->middleware('throttle:auth-refresh')
            ->name('token.refresh');

        Route::post('/password/request-otp', [PasswordRecoveryController::class, 'requestOtp'])
            ->middleware('throttle:auth-otp')
            ->name('password.request-otp');
        Route::post('/password/verify-otp', [PasswordRecoveryController::class, 'verifyOtp'])
            ->name('password.verify-otp');
        Route::post('/password/reset', [PasswordRecoveryController::class, 'reset'])
            ->name('password.reset');

        Route::middleware('auth.access')->group(function (): void {
            Route::get('/me', [SessionController::class, 'me'])->name('me');
            Route::post('/logout', [SessionController::class, 'logout'])->name('logout');
            Route::post('/logout-all', [SessionController::class, 'logoutAll'])->name('logout-all');
        });
    });

    Route::middleware(['auth.access', 'business.access'])
        ->prefix('businesses/{business}')
        ->name('api.v1.businesses.')
        ->group(function (): void {
            Route::get('/customers', [CustomerController::class, 'index'])->name('customers.index');
            Route::get('/customers/{customer}', [CustomerController::class, 'show'])
                ->whereUuid('customer')
                ->name('customers.show');
            Route::put('/customers/{customer}', [CustomerController::class, 'upsert'])
                ->whereUuid('customer')
                ->name('customers.upsert');
            Route::delete('/customers/{customer}', [CustomerController::class, 'archive'])
                ->whereUuid('customer')
                ->name('customers.archive');
            Route::post('/customers/{customer}/restore', [CustomerController::class, 'restore'])
                ->whereUuid('customer')
                ->name('customers.restore');
            Route::post('/customers/{customer}/photo', [CustomerController::class, 'updatePhoto'])
                ->whereUuid('customer')
                ->name('customers.photo.update');
            Route::delete('/customers/{customer}/photo', [CustomerController::class, 'removePhoto'])
                ->whereUuid('customer')
                ->name('customers.photo.remove');
        });
});
