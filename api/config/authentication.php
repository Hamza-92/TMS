<?php

return [
    'otp' => [
        'driver' => env('OTP_DELIVERY_DRIVER', 'log'),
        'digits' => 6,
        'ttl_minutes' => (int) env('OTP_TTL_MINUTES', 5),
        'max_attempts' => (int) env('OTP_MAX_ATTEMPTS', 5),
        'max_requests_per_hour' => (int) env('OTP_MAX_REQUESTS_PER_HOUR', 5),
        'resend_cooldown_seconds' => (int) env('OTP_RESEND_COOLDOWN_SECONDS', 60),
        'action_token_ttl_minutes' => (int) env('OTP_ACTION_TOKEN_TTL_MINUTES', 10),
    ],

    'tokens' => [
        'access_ttl_minutes' => (int) env('AUTH_ACCESS_TOKEN_TTL_MINUTES', 15),
        'refresh_ttl_days' => (int) env('AUTH_REFRESH_TOKEN_TTL_DAYS', 30),
    ],

    'trial' => [
        'plan_code' => env('AUTH_TRIAL_PLAN_CODE', 'demo'),
        'offline_grace_days' => (int) env('AUTH_OFFLINE_GRACE_DAYS', 3),
    ],

    'paid_subscription' => [
        'offline_grace_days' => (int) env('SUBSCRIPTION_OFFLINE_GRACE_DAYS', 3),
    ],
];
