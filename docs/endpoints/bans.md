# Bans & privileges

Penalties and grant/deny flags. Shared type: [`ActivePenalties`](/guide/common-types#penalty).

**spaceId:** [R6 primary](/guide/identifiers#space-ids). Marketplace privilege ID: [privilege IDs](/guide/identifiers#privilege-ids).

---

## Active penalties {#active-penalties}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/title/r6s/profiles/me/active_penalties" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Bans on **the authenticated** profile (`/me`).

### Response

```ts
type ActivePenalties = {
  profile_id: string
  bans: Array<{
    expiration_date: string
    level: string
    queue: string[]
    source: string // e.g. "cheating"
  }>
}
```

`queue` lists affected modes (`PVP_Ranked_Game`, `PVE_COOP_Game`, …). Empty `bans` means no active penalty on this surface.

---

## Player privileges {#player-privileges}

<Endpoint method="GET" path="/v2/profiles/{userId}/playerprivileges?spaceId={spaceId}&privilegeIds={privilegeId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Privilege check with full `reasons[]`.

### Query

| Name | Notes |
|---|---|
| `spaceId` | R6 primary for Siege |
| `privilegeIds` | e.g. marketplace `2798fec3-9010-4a24-b902-f21fa1b25e1f` |

### Response (per privilege)

```ts
type Privilege = {
  privilegeId: string
  isGranted: boolean
  isDefault?: boolean
  lastModifiedAt?: string
  displayValues?: unknown
  reasons: Array<{
    isGranted: boolean
    isDefault?: boolean
    lastModifiedAt?: string
    displayValues?: unknown
  }>
}
```

---

## GraphQL privilege {#graphql-privilege}

Same HTTP endpoint as the marketplace: [`POST /v1/profiles/me/uplay/graphql`](/endpoints/marketplace).

Operation `GetPlayerPrivilege` → `viewer.game.meta.privileges[].isGranted`.

Use this when you are already on the GraphQL stack; use [REST privileges](#player-privileges) when you need `reasons[]`.
