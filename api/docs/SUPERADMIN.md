# Superadmin portal

The internal web portal uses Laravel's session-based `admin` guard and the
separate `admin_users` table. Mobile users and mobile bearer tokens cannot
authenticate into this portal.

## Create the first superadmin

Add temporary values to the environment before running the seeder:

```env
SUPERADMIN_NAME="Platform Owner"
SUPERADMIN_EMAIL="owner@example.com"
SUPERADMIN_PASSWORD="use-a-long-unique-password"
```

Run:

```bash
php artisan db:seed --class=AdminUserSeeder --force
```

Remove `SUPERADMIN_PASSWORD` from the environment after the account has been
created, then rebuild the configuration cache. Never commit the credentials.

```bash
php artisan optimize:clear
php artisan config:cache
```

Open `/admin/login`. Only active admin accounts can sign in. Successful sign-in
and sign-out events are stored in `admin_audit_logs`, and the login endpoint is
limited to five attempts per minute for each email and IP combination.

## Current scope

- secure sign in and sign out;
- active-admin enforcement on every protected request;
- responsive portal navigation and dashboard;
- real business, user, subscription, pending-payment, and expiring-trial data;
- login activity audit records.

Business management, payment decisions, plan management, role permissions,
two-factor authentication, and admin password recovery are subsequent portal
milestones.

## Temporary OTP viewer

The portal can expose short-lived test OTPs to a signed-in superadmin while the
log delivery driver is active. Enable it only in development or staging:

```env
ADMIN_STAGING_TOOLS=true
OTP_DELIVERY_DRIVER=log
```

After changing the staging environment, rebuild the configuration cache:

```bash
php artisan optimize:clear
php artisan config:cache
```

Open `/admin/tools/otps`. Codes are encrypted in the configured cache, expire at
the same time as their challenge, and are deleted immediately after successful
verification. They are never added to API responses or stored as plaintext in
the OTP challenge table.

The feature refuses to run when `APP_ENV=production`, even if the toggle is set
incorrectly. Set `ADMIN_STAGING_TOOLS=false` before the production security
review, then remove the viewer after real WhatsApp delivery is verified.
