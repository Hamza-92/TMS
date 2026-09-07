<?php

use App\Http\Middleware\AuthenticateAccessToken;
use App\Http\Middleware\EnsureAdminHasRole;
use App\Http\Middleware\EnsureAdminIsActive;
use App\Http\Middleware\EnsureBusinessAccess;
use App\Http\Middleware\EnsureStagingToolsAreEnabled;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'auth.access' => AuthenticateAccessToken::class,
            'business.access' => EnsureBusinessAccess::class,
            'admin.active' => EnsureAdminIsActive::class,
            'admin.role' => EnsureAdminHasRole::class,
            'admin.staging-tools' => EnsureStagingToolsAreEnabled::class,
        ]);

        $middleware->redirectGuestsTo(fn (Request $request): string => route('admin.login'));
        $middleware->redirectUsersTo(fn (Request $request): string => route('admin.dashboard'));
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(
            fn (Request $request) => $request->is('api/*') || $request->expectsJson(),
        );

        $exceptions->render(function (ValidationException $exception, Request $request) {
            if (! $request->is('api/*')) {
                return null;
            }

            return response()->json([
                'success' => false,
                'message' => $exception->getMessage(),
                'code' => 'validation_failed',
                'errors' => $exception->errors(),
            ], $exception->status);
        });
    })->create();
