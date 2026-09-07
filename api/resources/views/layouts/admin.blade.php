<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="robots" content="noindex, nofollow">
    <title>@yield('title', 'Dashboard') · Tailor Admin</title>
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}?v={{ filemtime(public_path('css/admin.css')) }}">
    <script src="{{ asset('js/admin.js') }}?v={{ filemtime(public_path('js/admin.js')) }}" defer></script>
</head>
<body class="admin-app">
@php
    $admin = auth('admin')->user();
    $initials = collect(preg_split('/\s+/', trim($admin->name)) ?: [])
        ->filter()
        ->take(2)
        ->map(fn ($part) => mb_strtoupper(mb_substr($part, 0, 1)))
        ->implode('');
@endphp
<div class="admin-shell" data-admin-shell>
    <aside class="admin-sidebar" id="admin-sidebar" aria-label="Admin navigation">
        <div class="admin-brand">
            <span class="admin-brand__mark" aria-hidden="true">
                <img src="{{ asset('assets/images/sewing_machine_mark.webp') }}" alt="">
            </span>
            <span><strong>Tailor</strong><small>Management</small></span>
        </div>

        <nav class="admin-nav">
            <span class="admin-nav__label">Overview</span>
            <a @class(['admin-nav__item', 'is-active' => request()->routeIs('admin.dashboard')]) href="{{ route('admin.dashboard') }}" @if(request()->routeIs('admin.dashboard')) aria-current="page" @endif>
                <x-admin.icon name="dashboard" />
                <span>Dashboard</span>
            </a>

            <span class="admin-nav__label">Management</span>
            <a @class(['admin-nav__item', 'is-active' => request()->routeIs('admin.businesses.*')]) href="{{ route('admin.businesses.index') }}" @if(request()->routeIs('admin.businesses.*')) aria-current="page" @endif>
                <x-admin.icon name="business" />
                <span>Businesses</span>
            </a>
            @foreach ([
                ['users', 'Users'],
            ] as [$icon, $label])
                <span class="admin-nav__item is-disabled" aria-disabled="true" title="Coming in the next admin milestone">
                    <x-admin.icon :name="$icon" />
                    <span>{{ $label }}</span>
                    <small>Soon</small>
                </span>
            @endforeach
            <a @class(['admin-nav__item', 'is-active' => request()->routeIs('admin.plans.*')]) href="{{ route('admin.plans.index') }}" @if(request()->routeIs('admin.plans.*')) aria-current="page" @endif>
                <x-admin.icon name="subscription" />
                <span>Subscription plans</span>
            </a>
            <a @class(['admin-nav__item', 'is-active' => request()->routeIs('admin.payments.*')]) href="{{ route('admin.payments.index') }}" @if(request()->routeIs('admin.payments.*')) aria-current="page" @endif>
                <x-admin.icon name="payment" />
                <span>Payment requests</span>
            </a>

            <span class="admin-nav__label">System</span>
            @if (
                config('admin.staging_tools_enabled')
                && app()->environment(['local', 'testing', 'staging'])
                && config('authentication.otp.driver') === 'log'
                && $admin->role->value === 'superadmin'
            )
                <a @class(['admin-nav__item', 'is-active' => request()->routeIs('admin.tools.otps')]) href="{{ route('admin.tools.otps') }}" @if(request()->routeIs('admin.tools.otps')) aria-current="page" @endif>
                    <x-admin.icon name="key" />
                    <span>Test OTPs</span>
                </a>
            @endif
            <span class="admin-nav__item is-disabled" aria-disabled="true" title="Coming in the next admin milestone">
                <x-admin.icon name="audit" />
                <span>Audit logs</span>
                <small>Soon</small>
            </span>
            <span class="admin-nav__item is-disabled" aria-disabled="true" title="Coming in the next admin milestone">
                <x-admin.icon name="settings" />
                <span>Settings</span>
                <small>Soon</small>
            </span>
        </nav>

        <div class="admin-sidebar__footer">
            <form method="POST" action="{{ route('admin.logout') }}">
                @csrf
                <button class="admin-logout" type="submit">
                    <x-admin.icon name="logout" />
                    <span>Sign out</span>
                </button>
            </form>
        </div>
    </aside>

    <button class="admin-sidebar-backdrop" type="button" data-sidebar-close aria-label="Close navigation"></button>

    <main class="admin-main">
        <header class="admin-topbar">
            <button class="icon-button admin-menu-button" type="button" data-sidebar-open aria-controls="admin-sidebar" aria-expanded="false">
                <x-admin.icon name="menu" />
                <span class="sr-only">Open navigation</span>
            </button>
            <!-- <div class="admin-topbar__title">
                <span>Control center</span>
            </div> -->
            <div class="admin-profile">
                <span class="admin-profile__avatar">{{ $initials ?: 'SA' }}</span>
                <span class="admin-profile__copy"><strong>{{ $admin->name }}</strong><small>{{ str($admin->role->value)->headline() }}</small></span>
            </div>
        </header>

        <div class="admin-page">
            @if (session('status'))
                <div class="page-alert page-alert--success" role="status">
                    <span><x-admin.icon name="check" size="18" /></span>
                    <p>{{ session('status') }}</p>
                </div>
            @endif
            @if ($errors->has('business'))
                <div class="page-alert page-alert--danger" role="alert">
                    <span><x-admin.icon name="alert" size="18" /></span>
                    <p>{{ $errors->first('business') }}</p>
                </div>
            @endif
            @if ($errors->has('payment'))
                <div class="page-alert page-alert--danger" role="alert">
                    <span><x-admin.icon name="alert" size="18" /></span>
                    <p>{{ $errors->first('payment') }}</p>
                </div>
            @endif
            @if ($errors->has('plan'))
                <div class="page-alert page-alert--danger" role="alert">
                    <span><x-admin.icon name="alert" size="18" /></span>
                    <p>{{ $errors->first('plan') }}</p>
                </div>
            @endif
            @yield('content')
        </div>
    </main>
</div>
</body>
</html>
