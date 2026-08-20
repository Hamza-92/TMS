# Tailor App architecture

```text
Flutter UI
    ↓
Application / Repository Layer
    ↓
Drift + SQLite
    ↓
Sync Layer
    ↓
Laravel REST API (/api/v1)
    ↓
MySQL
```

SQLite/local storage is the mobile application's primary operational data
source. Laravel provides server-side services such as synchronization, backup,
accounts, subscription management, and recovery.

## Offline-first boundary

The UI will eventually call feature application/repository code. Repositories
write to Drift immediately and expose local data back to the UI. Future sync
code observes pending local changes and communicates with Laravel when a network
is available. A normal create or update operation must not depend on a
successful HTTP response.

UUIDs are generated on the device so records created offline do not depend on
MySQL auto-increment identifiers. Conflict rules, retry queues, and complete
business schemas are intentionally deferred.

## API boundary

All mobile-facing endpoints live below `/api/v1`. Laravel will own accounts,
authentication, shops, subscriptions, devices, backup/recovery, remote files,
notifications, and app-version services as those features are added.
