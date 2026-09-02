<?php

namespace App\Http\Middleware;

use App\Models\AdminUser;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class EnsureAdminHasRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        /** @var AdminUser|null $admin */
        $admin = Auth::guard('admin')->user();

        abort_unless(
            $admin !== null && in_array($admin->role->value, $roles, true),
            Response::HTTP_FORBIDDEN,
        );

        return $next($request);
    }
}
