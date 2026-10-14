# User & profile

Account identity, linked platforms, names, friends, and activity. Types: [`UserMe`](/guide/common-types#user-me), [`LinkedProfile`](/guide/common-types#linked-profile).

Default [app ID](/guide/identifiers#app-ids): Main Auth `4391c956-…`. [Headers](/guide/headers) are standard ticket headers unless noted.

---

## Current user {#current-user}

<Endpoint method="GET" path="/v3/users/me" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Full user record for the ticket: `userId`, `nameOnPlatform`, `dateCreated`, `dateOfBirth`, email flags, country, and related account fields.

### Response

[`UserMe`](/guide/common-types#user-me) plus additional account flags.

<Endpoint method="GET" path="/v3/users/{userId}?fields=" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Same record by id. Optional `fields` is a field filter used by account.ubisoft.com.

<Endpoint method="PUT" path="/v3/users/{userId}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Save user fields (account site `saveUserProfile`). Body is the remaining user payload after `profileId` is taken from the path.

<Endpoint method="POST" path="/v3/users/{userId}/validateUpdate" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Dry-run for that save. Body is the same remaining user fields.

---

## Delete account {#delete-account}

<Endpoint method="DELETE" path="/v3/users/me" appId="Account management afb4b43c-…" appHref="/guide/identifiers#app-ids" />

Permanently deletes **your** account. Official UI also runs extra confirmation; do not call this from a tool unless that is explicitly the user's action.

Exchange to the [account-management app ID](/guide/ticket-exchange) first.

<Endpoint method="DELETE" path="/v3/users/{userId}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Same delete keyed by user id (account site `deleteUserAccountById`).

---

## Create account {#create-account}

<Endpoint method="POST" path="/v3/users" auth="none" appId="Account management afb4b43c-…" appHref="/guide/identifiers#app-ids" />

Create a new Ubisoft account (`validateCreation` on the website). Body includes email, password, country, legal opt-ins, age. Some SDK clients instead `POST /v1/users` with `email`, `confirmedEmail`, `password`, `nameOnPlatform`, `dateOfBirth`, `country`, `preferredLanguage`, `legalOptinsKey`, `isDateOfBirthApprox`.

---

## Linked profiles {#linked-profiles}

<Endpoint method="GET" path="/v3/users/{userId}/Profiles" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Also `GET /v3/users/me/profiles` for the current user, and `GET /v3/profiles/{profileId}` for one profile.

### URL parameters

| Name | Meaning |
|---|---|
| `userId` | Ubisoft user UUID from [`Session`](/guide/common-types#session) or `/v3/users/me` |

### Response

```ts
type ProfilesResponse = {
  profiles: LinkedProfile[]
}
```

[`LinkedProfile`](/guide/common-types#linked-profile): `profileId`, `platformType` (`uplay` / `xbl` / `psn` / `steam` / `amazon` / `discord` / `epic`), `idOnPlatform`, `nameOnPlatform`.

---

## Unlink platform {#unlink-platform}

<Endpoint method="DELETE" path="/v3/users/{userId}/profiles/{profileId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Unlink one platform (Epic, Discord, …) from **your** user. `profileId` comes from [linked profiles](#linked-profiles). `200` or `204`.

Optional body (account site):

```ts
type UnlinkBody = {
  platformType: PlatformType
  nameOnPlatform: string
}
```

---

## Initial / ghost profiles {#initial-profiles}

<Endpoint method="GET" path="/v3/users/{userId}/InitialProfiles" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Platforms Ubisoft has seen even if they are not in `/Profiles`. account.ubisoft.com calls the same path with lowercase `/initialProfiles`.

**Ghost linked:** an XBL or PSN row appears here but **not** in [`/Profiles`](#linked-profiles). Compare the two lists.

---

## Lookup by name {#lookup-by-name}

<Endpoint method="GET" path="/v3/profiles?nameOnPlatform={name}&platformType=uplay" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Resolve a username on a platform.

### Query

| Name | Notes |
|---|---|
| `nameOnPlatform` | Exact display name |
| `platformType` | Usually `uplay`; other [`PlatformType`](/guide/common-types#platform-type) values work for that network |

### Response

`{ profiles: LinkedProfile[] }`. Empty list if nobody matches.

---

## Profiles by userId {#profiles-by-userid}

<Endpoint method="GET" path="/v3/profiles?userids={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Same `LinkedProfile[]` keyed by Ubisoft `userId`. `userids` can be comma-separated for a small batch.

account.ubisoft.com also sends `userIds`, `profileIds`, `namesOnPlatform`, and `idsOnPlatform` (comma-separated) on `GET /v3/profiles`, with `platformType`.

---

## V2 profiles {#v2-profiles}

<Endpoint method="GET" path="/v2/profiles?userId={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Older profile payload. Prefer v3 unless you are matching a legacy client.

---

## Rename {#rename}

<Endpoint method="PUT" path="/v3/profiles/{profileId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Change `nameOnPlatform` on a profile you own (rate-limited / cooldown on Ubisoft's side).

### Body

```ts
type RenameBody = {
  nameOnPlatform: string
}
```

Call [validate](#validate-rename) first if you want the same checks the official UI runs.

---

## Validate rename {#validate-rename}

<Endpoint method="POST" path="/v3/profiles/{profileId}/validateUpdate" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Dry-run for a username change. Body matches [rename](#rename). Errors here are cheaper than a rejected `PUT`.

---

## Persona / nickname {#persona}

<Endpoint method="PUT" path="/v1/profiles/{profileId}/persona?spaceId={spaceId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Per-space nickname (not the account-wide uplay name).

### Query

`spaceId` — e.g. [R6 primary](/guide/identifiers#space-ids).

### Body

```ts
type PersonaBody = {
  nickname: string
  obj: { enabled: boolean }
}
```

---

## Current profile v1 {#current-profile-v1}

<Endpoint method="GET" path="/v1/profiles/me" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Small payload whose useful field is `userId`. Used to recover the user UUID from a ticket when you did not keep the [`Session`](/guide/common-types#session).

---

## Application history {#application-history}

<Endpoint method="GET" path="/v1/profiles/applications?profileIds={id}&limit={n}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v3/profiles/applications?profileIds={id}&limit={n}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Games / applications associated with a profile. v3 is the newer schema; v1 still answers. `limit` is a page size.

---

## Games played {#games-played}

<Endpoint method="GET" path="/v1/profiles/me/gamesplayed" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Per-title play history for the current user.

Connect website variant (same path on [Connect](/guide/environments), plus a per-profile URL):

<Endpoint method="GET" path="/v1/profiles/me/gamesplayed" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/profiles/{profileId}/gamesplayed" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Query used by account.ubisoft.com: `spaceIds`, `spacePlatformTypes`, `applicationPlatformTypes` (comma-separated), `limit`.

### Response

[`GamesPlayedEntry[]`](/guide/common-types#games-played): `spaceId`, `platformType`, `firstPlayed` / `lastPlayed` (date + location), `sessionsCount`.

Visibility of this data to other users is gated by the [`gamesplayed` consent](/endpoints/consent).

---

## Metaprogression {#metaprogression}

Connect economy level / XP for a profile (not Siege clearance).

<Endpoint method="GET" path="/v1/profiles/{profileId}/global/ubiconnect/economy/api/metaprogression" appId="Connect PC 83564d31-…" appHref="/guide/identifiers#app-ids" />

```ts
type Metaprogression = {
  level: number
  xp: number
}
```

---

## Friends {#friends}

<Endpoint method="GET" path="/v2/profiles/me/friends" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v3/profiles/{profileId}/friends" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="DELETE" path="/v3/profiles/{profileId}/friends/{friendProfileId}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Friends list: `profileId`, username, date modified, relationship state. Subject to [`friends` consent](/endpoints/consent).

Send a request: GraphQL [`SendFriendRequestMutation`](/endpoints/marketplace#send-friend-request).

---

## Parties {#parties}

<Endpoint method="GET" path="/v1/profiles/{userId}/parties?spaceId={spaceId}" appId="Party 0a0379c0-…" appHref="/guide/identifiers#app-ids" />

Active parties for a user in a space.

```ts
type PartiesResponse = {
  parties: Array<{ partyId: string }>
}
```

Invites use GraphQL [`SendPartyInvitationMutation`](/endpoints/marketplace#send-party-invitation) with this `partyId`. Exchange to the [party app ID](/guide/ticket-exchange).

---

## Action log {#action-log}

<Endpoint method="GET" path="/v3/profiles/me/actionLog?offset=0&limit=10" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Login / device history for **your** account.

### Query

`offset`, `limit` — start at `0` / `10` and page. account.ubisoft.com defaults `limit` to `5`.

### Response

[`ActionLogEntry[]`](/guide/common-types#action-log): `applicationId`, `ipAddress`, `dateCreated`, `sessionId`, `credentialType`, `platformDeviceId`.
