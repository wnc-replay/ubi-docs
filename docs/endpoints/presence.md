# Presence

## Online status {#online-status}

<Endpoint method="GET" path="/v1/users/onlineStatuses?userIds={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Online flag plus active connections (which game / space the user is in).

### Query

| Name | Notes |
|---|---|
| `userIds` | One UUID, or a comma-separated list |

### Headers

[Standard headers](/guide/headers). Official clients also send `ubi-profileid`.

### Response

[`OnlineStatus`](/guide/common-types#online-status) (often wrapped in an array or `{ onlineStatuses: [...] }`).

Each connection may include `platformType`, `applicationId`, `spaceId`, `stagingSpaceId`, `playingTime`.

Whether others can see this is gated by [`online` consent](/endpoints/consent).
