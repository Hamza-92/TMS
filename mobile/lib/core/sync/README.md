# Customer synchronization

Customer management is the first implemented offline-first feature:

1. The repository saves a customer to Drift/SQLite immediately.
2. A durable sync operation is queued in the same database transaction.
3. Customer screens read only from the local database.
4. While the customer list is open, synchronization runs immediately, on
   manual refresh, and every 30 seconds.
5. The repository pushes queued writes in creation order, then incrementally
   pulls server changes.
6. Successful responses replace the local server version and clear the pending
   state.

Customer photos are copied to app-owned storage first, so they display without
a connection. A changed photo is uploaded or removed through the protected
customer photo endpoint as part of the pending upsert retry. The local file is
preferred for display; the server URL allows the photo to appear on other
devices after synchronization.

New customer UUIDs and operation UUIDs are created on the device. Server
versions detect edits made from another device, while operation UUIDs make
retries safe. A version conflict preserves the local edit, stores the server's
new version, and marks the record for review/retry instead of silently losing
either side.

Archiving is synchronized as a state change rather than a destructive delete.
A customer created and archived before its first successful upload can be
removed locally because no server history exists yet.

Authentication still requires connectivity. Normal customer creation and
editing do not.
