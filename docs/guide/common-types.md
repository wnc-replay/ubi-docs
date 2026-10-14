# Common types

These TypeScript shapes are the **shared** contracts. Endpoint pages only add fields that are unique to that route.

Field names match JSON as returned by ubi-services (camelCase unless noted). Dates are ISO-8601 strings unless noted.

## Session {#session}

Returned by [`POST /v3/profiles/sessions`](/endpoints/auth#create-session) and by every [ticket exchange](/guide/ticket-exchange).

```ts
type Session = {
  platformType: string // e.g. "uplay"
  ticket: string | null
  twoFactorAuthenticationTicket: string | null
  codeCommunicationPreference?: string // e.g. email / authenticator, when 2FA is pending
  profileId: string
  userId: string
  nameOnPlatform: string
  environment: string
  expiration: string
  spaceId?: string
  clientIp?: string
  clientIpCountry?: string
  serverTime?: string
  sessionId: string
  sessionKey?: string
  rememberMeTicket: string | null
  dateOfBirth?: string
}
```

`ticket` is a full session. `twoFactorAuthenticationTicket` is a separate, limited-scope credential — usable as `ubi_v1 t=…` but not equivalent to `ticket`. See [2FA](/guide/authentication#two-factor).

## Platform type {#platform-type}

```ts
type PlatformType =
  | 'uplay'
  | 'xbl'
  | 'psn'
  | 'steam'
  | 'amazon'
  | 'discord'
  | 'epic'
```

Other values appear occasionally (`stadia` historical, etc.). Treat unknown strings as opaque.

## Linked profile {#linked-profile}

From [`GET /v3/users/{userId}/Profiles`](/endpoints/user#linked-profiles) and username lookup.

```ts
type LinkedProfile = {
  profileId: string
  userId: string
  platformType: PlatformType
  idOnPlatform: string
  nameOnPlatform: string
}
```

## User (me) {#user-me}

Subset of [`GET /v3/users/me`](/endpoints/user#current-user). Extra email/country flags exist; these are the ones tools actually need.

```ts
type UserMe = {
  userId: string
  username?: string
  nameOnPlatform: string
  dateCreated: string
  dateOfBirth?: string
  email?: string
  country?: string
  legalOptIns?: unknown
}
```

## Inventory item {#inventory-item}

```ts
type InventoryItem = {
  itemId: string
  /** Present for currencies / stackables. Cosmetics omit this. */
  quantity?: number
}

type InventoryResponse = {
  items: InventoryItem[]
}
```

Known currency IDs: [Item IDs](/guide/identifiers#item-ids).

## Catalogue item {#catalogue-item}

After [decompressing](/guide/compressed-payloads) `compressedItems`:

```ts
type CatalogueItem = {
  itemId: string
  name: string
  tags: string[]
  item_type: string
}
```

## Skill profile (Ranked 2.0 / 3.0) {#skill-profile}

From [`full_profiles`](/endpoints/stats#current-ranked) / [`archived_profile`](/endpoints/stats#archived-ranked).

```ts
type SkillProfile = {
  profile: {
    board_id: string
    id: string
    max_rank: number
    max_rank_points: number
    platform_family: 'pc' | 'console'
    rank: number // 0–36
    rank_points: number
    season_id: number
    top_rank_position: number
  }
  season_statistics: {
    deaths: number
    kills: number
    match_outcomes: {
      abandons: number
      losses: number
      wins: number
    }
  }
}
```

`rank` `0` is unranked. Exact board IDs vary (`ranked`, `standard`, …).

## Penalty {#penalty}

```ts
type ActivePenalties = {
  profile_id: string
  bans: Array<{
    expiration_date: string
    level: string
    queue: string[] // e.g. "PVP_Ranked_Game", "PVE_COOP_Game"
    source: string // e.g. "cheating"
  }>
}
```

## Games played entry {#games-played}

```ts
type GamesPlayedEntry = {
  spaceId: string
  platformType: PlatformType
  firstPlayed: { date: string; location?: string }
  lastPlayed: { date: string; location?: string }
  sessionsCount: number
}
```

## Action log row {#action-log}

```ts
type ActionLogEntry = {
  applicationId: string
  ipAddress: string
  dateCreated: string
  sessionId: string
  credentialType?: string
  platformDeviceId?: string
}
```

## Online status {#online-status}

```ts
type OnlineStatus = {
  userId: string
  onlineStatus?: string
  connections?: Array<{
    connectionId?: string
    platformType: PlatformType
    applicationId?: string
    spaceId?: string
    stagingSpaceId?: string
    playingTime?: number
  }>
}
```
