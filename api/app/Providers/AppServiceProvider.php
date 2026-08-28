<?php

namespace App\Providers;

use App\Contracts\OtpDeliveryGateway;
use App\Services\Otp\LogOtpDeliveryGateway;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use LogicException;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(OtpDeliveryGateway::class, function (): OtpDeliveryGateway {
            if (config('authentication.otp.driver') !== 'log') {
                throw new LogicException('The configured OTP delivery driver is not installed.');
            }

            return new LogOtpDeliveryGateway;
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        RateLimiter::for('auth-otp', function (Request $request): Limit {
            $key = $request->ip().'|'.mb_strtolower((string) $request->input('phone_e164'));

            return Limit::perHour((int) config('authentication.otp.max_requests_per_hour'))
                ->by($key);
        });

        RateLimiter::for('auth-login', fn (Request $request): Limit => Limit::perMinute(10)
            ->by($request->ip().'|'.mb_strtolower((string) $request->input('phone_e164'))));

        RateLimiter::for('auth-refresh', fn (Request $request): Limit => Limit::perMinute(30)
            ->by($request->ip()));
    }
}
