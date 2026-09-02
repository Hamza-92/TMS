<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="robots" content="noindex, nofollow">
    <title>Sign in · Tailor Superadmin</title>
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}">
    <script src="{{ asset('js/admin.js') }}" defer></script>
</head>
<body class="admin-login-page">
<main class="admin-login-shell">
    <section class="admin-login-brand" aria-label="Tailor Manager">
        <div class="login-orb login-orb--one"></div>
        <div class="login-orb login-orb--two"></div>
        <div class="admin-brand admin-brand--light">
            <span class="admin-brand__mark" aria-hidden="true">
                <img src="{{ asset('assets/images/sewing_machine_mark.webp') }}" alt="">
            </span>
            <span><strong>Tailor</strong><small>Superadmin</small></span>
        </div>
        <div class="admin-login-brand__content">
            <span class="access-badge"><i></i>Internal control center</span>
            <h1>Manage every tailor business with confidence.</h1>
            <p>Review subscriptions, support customers, verify payments and keep the SaaS platform healthy from one secure workspace.</p>
        </div>
        <p class="admin-login-brand__foot">Internal access only · Activity is securely audited</p>
    </section>

    <section class="admin-login-panel">
        <div class="admin-login-card">
            <div class="admin-login-mobile-brand">
                <span class="admin-brand__mark" aria-hidden="true">
                    <img src="{{ asset('assets/images/sewing_machine_mark.webp') }}" alt="">
                </span>
                <span><strong>Tailor</strong><small>Superadmin</small></span>
            </div>

            <div class="admin-login-card__heading">
                <span class="eyebrow">Secure administration</span>
                <h2>Welcome back</h2>
                <p>Sign in with your authorized administrator account.</p>
            </div>

            @if (session('status'))
                <div class="form-alert form-alert--success" role="status">{{ session('status') }}</div>
            @endif

            <form method="POST" action="{{ route('admin.login.store') }}" novalidate>
                @csrf
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input id="email" name="email" type="email" value="{{ old('email') }}" autocomplete="username" inputmode="email" placeholder="admin@example.com" class="{{ $errors->has('email') ? 'has-error' : '' }}" autofocus>
                    @error('email')<p class="field-error" role="alert">{{ $message }}</p>@enderror
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-field">
                        <input id="password" name="password" type="password" autocomplete="current-password" placeholder="Enter your password" class="{{ $errors->has('password') ? 'has-error' : '' }}">
                        <button type="button" data-password-toggle aria-label="Show password" aria-pressed="false">
                            <x-admin.icon name="eye" />
                        </button>
                    </div>
                    @error('password')<p class="field-error" role="alert">{{ $message }}</p>@enderror
                </div>

                <div class="form-options">
                    <label class="checkbox-field">
                        <input type="checkbox" name="remember" value="1" @checked(old('remember'))>
                        <span>Keep me signed in on this device</span>
                    </label>
                </div>

                <button class="primary-button" type="submit">Sign in to dashboard</button>
            </form>

            <p class="admin-login-help">Having trouble signing in? Ask the account owner to verify your admin status.</p>
        </div>
    </section>
</main>
</body>
</html>
