<?php

namespace App\Http\Middleware;

use App\Enums\AdminStatus;
use Closure;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class EnsureAdminIsActive
{
    public function handle(Request $request, Closure $next): Response|RedirectResponse
    {
        $admin = Auth::guard('admin')->user();

        if ($admin !== null && $admin->status === AdminStatus::Active) {
            return $next($request);
        }

        Auth::guard('admin')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()
            ->route('admin.login')
            ->withErrors(['email' => 'Your admin access is unavailable. Contact the account owner.']);
    }
}
