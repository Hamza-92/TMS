<?php

namespace App\Http\Controllers\Admin\Auth;

use App\Enums\AdminStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\LoginRequest;
use App\Models\AdminAuditLog;
use App\Models\AdminUser;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Illuminate\View\View;

class AuthenticatedSessionController extends Controller
{
    public function create(): View
    {
        return view('admin.auth.login');
    }

    /** @throws ValidationException */
    public function store(LoginRequest $request): RedirectResponse
    {
        $credentials = [
            'email' => mb_strtolower($request->string('email')->trim()->value()),
            'password' => $request->string('password')->value(),
            'status' => AdminStatus::Active->value,
        ];

        if (! Auth::guard('admin')->attempt($credentials, $request->boolean('remember'))) {
            throw ValidationException::withMessages([
                'email' => 'The email or password is incorrect.',
            ]);
        }

        $request->session()->regenerate();

        /** @var AdminUser $admin */
        $admin = Auth::guard('admin')->user();
        $admin->forceFill([
            'last_login_at' => now(),
            'last_login_ip' => $request->ip(),
        ])->save();

        AdminAuditLog::query()->create([
            'admin_user_id' => $admin->id,
            'action' => 'admin.signed_in',
            'subject_type' => AdminUser::class,
            'subject_id' => $admin->id,
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return redirect()->intended(route('admin.dashboard'));
    }

    public function destroy(Request $request): RedirectResponse
    {
        /** @var AdminUser|null $admin */
        $admin = Auth::guard('admin')->user();

        if ($admin !== null) {
            AdminAuditLog::query()->create([
                'admin_user_id' => $admin->id,
                'action' => 'admin.signed_out',
                'subject_type' => AdminUser::class,
                'subject_id' => $admin->id,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);
        }

        Auth::guard('admin')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()
            ->route('admin.login')
            ->with('status', 'You have been signed out securely.');
    }
}
