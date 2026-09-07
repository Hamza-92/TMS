# Customers API

Customer endpoints are tenant-scoped below
`/api/v1/businesses/{business_id}/customers`. Every request requires a valid
access token, active business membership, and an active or usable trial/subscription.

```http
Authorization: Bearer ACCESS_TOKEN
Accept: application/json
Content-Type: application/json
```

## Endpoints

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/customers` | List customers changed on the server |
| GET | `/customers/{client_uuid}` | Read one customer |
| PUT | `/customers/{client_uuid}` | Create or update a customer |
| DELETE | `/customers/{client_uuid}` | Archive a customer without deleting history |
| POST | `/customers/{client_uuid}/restore` | Restore an archived customer |
| POST | `/customers/{client_uuid}/photo` | Upload or replace a customer photo |
| DELETE | `/customers/{client_uuid}/photo` | Remove a customer photo |

The list endpoint accepts `status=active|archived|all`, `search`,
`updated_since`, `page`, and `per_page` (maximum 100). Its `meta.synced_at`
value is the cursor the mobile app stores for the next incremental pull.

## Create or update

The device generates both UUID values before calling the API. Use
`base_version: 0` for a new customer and the latest server version when editing.

```json
{
  "operation_uuid": "440ee73b-50d4-4cd8-a805-c31982f908ae",
  "base_version": 0,
  "name": "Ayesha Khan",
  "phone_e164": "+923001234567",
  "alternate_phone_e164": null,
  "address": "Main Bazaar",
  "notes": "Prefers WhatsApp"
}
```

Successful writes return the authoritative customer and its incremented
`version`. Repeating exactly the same request with the same `operation_uuid` is
safe: the server replays the result rather than creating a duplicate.

Archive and restore requests use this smaller body:

```json
{
  "operation_uuid": "698b6454-d8d4-4439-9e0d-76365b649324",
  "base_version": 2
}
```

Photo uploads use `multipart/form-data` with a `photo` field. JPG, PNG, and
WebP files up to 5 MB are accepted. Customer responses expose an absolute
`photo_url` when a server copy exists.

## Offline and conflict rules

- `client_uuid` identifies the same customer on the device and server.
- `operation_uuid` makes network retries idempotent.
- `version` provides optimistic concurrency. A stale `base_version` receives
  HTTP `409` with code `customer_version_conflict` and the current server record.
- Reusing an operation UUID with different content receives HTTP `409` with
  code `customer_operation_conflict`.
- Exceeding the subscription's customer limit receives HTTP `422` with code
  `customer_limit_reached`.
- Archiving is a soft state change. Customer history is preserved and the
  customer can be restored.

The Flutter client always writes to SQLite first. It queues the operation,
shows the saved customer immediately, and retries synchronization when the
network is available.
