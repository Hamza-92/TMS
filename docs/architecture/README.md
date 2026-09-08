# Tailor App architecture

```text
Flutter UI
    -> Application / repository layer
    -> Drift + SQLite
    -> Synchronization queue
    -> Laravel REST API (/api/v1)
    -> MySQL
```

SQLite/local storage is the mobile application's primary operational data
source. Laravel provides synchronization, backup, accounts, subscription
management, and recovery.

## Offline-first boundary

The UI calls feature application/repository code. Repositories write to Drift
immediately and expose local data back to the UI. Sync code observes pending
local changes and communicates with Laravel when a network is available. A
normal create or update operation does not depend on a successful HTTP response.

UUIDs are generated on the device so records created offline do not depend on
MySQL identifiers. Customer synchronization implements durable retry operations,
idempotency, incremental pulls, and optimistic version conflicts. The same
boundary now supports measurement templates and customer measurement profiles.
Template definitions and customer revisions are immutable, while profile
metadata is versioned. Orders will later copy a chosen measurement revision into
an order-item snapshot so subsequent edits cannot change historical work.

## API and tenant boundary

All mobile-facing endpoints live below `/api/v1`. Protected business endpoints
require both a valid access token and access to the business in the URL. Laravel
owns accounts, authorization, shops, subscriptions, backup/recovery, remote
files, notifications, and app-version services.

Customer records are never shared across businesses. Subscription availability
and plan limits are checked again on the server; the mobile UI is not treated as
an authorization boundary.
