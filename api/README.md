# Tailor API

Laravel 13 API foundation for Tailor Management server-side services. Mobile
routes are versioned below `/api/v1`; the only business-free endpoint currently
implemented is the public `GET /api/v1/health` check.

## SaaS foundation

The schema currently covers:

- phone-first customer accounts, devices, refreshable sessions, and OTP challenges;
- businesses, memberships, invitations, localization, and tenant status;
- demo and paid plans, subscription history, Google Play or offline payments;
- WhatsApp message delivery records and trial-abuse protection;
- separate superadmin identities, payment approval, audit logs, and account deletion.

All primary application records use ULIDs. The initial user and Sanctum migrations
were updated accordingly, so an older local development database created before
this foundation must be rebuilt before applying the schema. Do not run
`migrate:fresh` against a database containing data that must be preserved.

## Seed data

`DatabaseSeeder` always creates the safe 14-day `demo` plan. It creates a
superadmin only when `SUPERADMIN_EMAIL` and `SUPERADMIN_PASSWORD` are present in
the environment; no default admin password is included.

Mobile authentication uses short-lived opaque access tokens and rotating refresh
tokens stored only as hashes in `auth_sessions`. Sanctum remains installed for
possible future first-party integrations. MySQL is configured via `.env`; no
credentials are committed. See the repository root README for setup and
LAN-device instructions.

The implemented phone authentication endpoints, local OTP testing workflow, and
Laravel API terminology are documented in `docs/AUTHENTICATION_API.md`.

The internal session-based superadmin portal is available at `/admin/login`.
Account creation, security behavior, and current portal scope are documented in
`docs/SUPERADMIN.md`.
