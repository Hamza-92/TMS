# Tailor API

Laravel 13 API foundation for Tailor Management server-side services. Mobile
routes are versioned below `/api/v1`; the only business-free endpoint currently
implemented is the public `GET /api/v1/health` check.

Sanctum is installed for future token authentication. MySQL is configured via
`.env`; no credentials are committed. See the repository root README for setup
and LAN-device instructions.
