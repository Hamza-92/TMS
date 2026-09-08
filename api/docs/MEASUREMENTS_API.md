# Measurements API

All endpoints are below `/api/v1/businesses/{business}` and require:

```http
Authorization: Bearer ACCESS_TOKEN
Accept: application/json
Content-Type: application/json
```

The business middleware verifies membership, subscription access, and tenant
isolation. System templates are readable by every active business. Business
templates belong to one tenant and may be changed only by owners and managers.

## Template endpoints

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/measurement-templates` | List system and business templates |
| GET | `/measurement-templates/{template_uuid}` | Read the current definition |
| GET | `/measurement-templates/{template_uuid}/versions/{number}` | Read an immutable historical definition |
| PUT | `/measurement-templates/{template_uuid}` | Create or update a business template |
| DELETE | `/measurement-templates/{template_uuid}` | Archive a business template |
| POST | `/measurement-templates/{template_uuid}/restore` | Restore a business template |

The list accepts `search`, `category`, `status=active|archived|all`,
`updated_since`, `page`, and `per_page` (maximum 100).

Every successful template update creates a new immutable definition version.
Profiles already pinned to an older version continue to use it.

### Create a business template

```json
{
  "operation_uuid": "UUID",
  "base_version": 0,
  "source_template_uuid": "OPTIONAL_TEMPLATE_UUID",
  "name": "Regular Shalwar Kameez",
  "name_ur": "ریگولر شلوار قمیض",
  "name_roman_ur": "Regular Shalwar Kameez",
  "category": "shalwar_kameez",
  "default_unit": "inch",
  "description": null,
  "fields": [
    {
      "client_uuid": "UUID",
      "field_key": "kameez_length",
      "label": "Kameez length",
      "label_ur": "قمیض کی لمبائی",
      "label_roman_ur": "Kameez ki lambai",
      "section": "upper_garment",
      "value_type": "number",
      "unit_type": "length",
      "is_required": true,
      "minimum_value_mm": 100,
      "maximum_value_mm": 2000,
      "sort_order": 0
    }
  ]
}
```

Use `base_version: 0` only for creation. An update sends the complete current
definition and the template's current `version` as `base_version`.

## Customer measurement profile endpoints

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/customers/{customer_uuid}/measurement-profiles` | List a customer's profiles |
| GET | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}` | Read one profile and its latest revision |
| PUT | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}` | Create or update profile metadata |
| DELETE | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}` | Archive a profile |
| POST | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}/restore` | Restore a profile |
| GET | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}/revisions` | Read immutable revision history |
| POST | `/customers/{customer_uuid}/measurement-profiles/{profile_uuid}/revisions` | Add an immutable revision |

The profile list accepts `status=active|archived|all`, `updated_since`, `page`,
and `per_page`.

### Create a profile

```json
{
  "operation_uuid": "UUID",
  "base_version": 0,
  "template_client_uuid": "UUID",
  "template_definition_version": 1,
  "name": "Regular Kameez",
  "preferred_unit": "inch",
  "notes": null
}
```

### Add measurements

```json
{
  "operation_uuid": "UUID",
  "base_version": 1,
  "revision_client_uuid": "UUID",
  "measured_at": "2026-09-08T10:30:00+05:00",
  "notes": "Allow a little ease.",
  "values": [
    {
      "field_uuid": "UUID_FROM_PINNED_TEMPLATE_VERSION",
      "value": 40.25,
      "unit": "inch"
    }
  ]
}
```

Length values retain the entered value and unit and also receive a normalized
`value_mm`. This permits reliable inch/centimetre display and later reporting.
Text fields use `unit: null` and `value_mm: null`.

## Offline and history rules

- `client_uuid` identifies the same template or profile on every device.
- `operation_uuid` makes retries idempotent. Reusing it with different content
  returns HTTP `409` with `measurement_operation_conflict`.
- `version` provides optimistic concurrency. Stale writes receive HTTP `409`
  with the latest server record.
- Template definitions and measurement revisions are append-only.
- Updating measurements adds a revision and increments the profile version;
  older revisions are never overwritten.
- Archiving retains history and supports restoration.
- Permanently deleting a customer removes their measurement profiles and
  revisions while the customer sync tombstone remains.

The Flutter repository should write templates, profiles, and revisions to its
local database first, enqueue the operation in the same transaction, and sync
later using these idempotency and version fields.
