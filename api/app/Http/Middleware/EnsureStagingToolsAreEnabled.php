<?php

namespace App\Http\Middleware;

use App\Services\Otp\StagingOtpVault;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureStagingToolsAreEnabled
{
    public function __construct(private readonly StagingOtpVault $stagingOtpVault) {}

    public function handle(Request $request, Closure $next): Response
    {
        abort_unless($this->stagingOtpVault->enabled(), Response::HTTP_NOT_FOUND);

        return $next($request);
    }
}
