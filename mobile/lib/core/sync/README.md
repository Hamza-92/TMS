# Sync foundation

The future synchronization flow is local-first:

1. Save the user's action to Drift/SQLite immediately.
2. Mark the resulting record or change as pending.
3. Attempt synchronization when connectivity is available.
4. Send pending changes to the versioned Laravel API.
5. Persist server-side data in MySQL.

Normal tailor data must remain writable without an internet connection. UI code
must read and write through the local application/repository layer, not wait on
an HTTP response.
