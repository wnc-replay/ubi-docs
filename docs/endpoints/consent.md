# Consent & privacy

Per-category visibility (`public` / `friendsOnly` / `private`) for stats, avatar, name, and so on. Tracker sites and friend suggestions honor these flags.

The **v2** routes below are what account.ubisoft.com and the R6 PC client actually PATCH. The v1 `/consents/categories/{key}` paths still exist.

::: tip Required ticket
Writes only stick if you [exchange](/guide/ticket-exchange) to the **R6 Siege PC** app ID `e3d5ea9e-50bd-43b7-88bf-39794f4e3d40` first. Login is often with Connect client `f68a4bb5-…`, then exchange.
:::

[Headers](/guide/headers) otherwise standard. `Ubi-appid` (any casing) is accepted.

---

## Keys {#keys}

v2 PATCH uses the **consent ID**. v1 category URLs use the **key**.

| Key | Consent ID | Controls |
|---|---|---|
| `stats` | `8f31dfaa-325e-4bb6-8e2b-cd8405e10fa3` | Stats visibility (tracker.gg and similar) |
| `avatar` | `39f38da2-6c54-4449-ab54-b85ee5b4bd24` | Avatar visibility |
| `name` | `43c649b5-6ca6-4ce9-8a6b-0c4960f66da0` | Name on platform |
| `online` | `5f9d3a6c-43e3-4b07-97eb-b878ad63273e` | [Online status](/endpoints/presence) |
| `profile` | `76c93e10-5a8b-49a8-925c-a9bd5422851a` | Profile visibility |
| `gamesplayed` | `95f7efb4-77c5-4d9e-b00e-791c93019aad` | [Games played](/endpoints/user#games-played) |
| `friends` | `e55011c6-9862-4ef5-b4c1-0cdcac251cb2` | Friends suggestions |

```ts
type ConsentVisibility = 'public' | 'friendsOnly' | 'private'
```

---

## Read consents (v2) {#read-v2}

<Endpoint method="GET" path="/v2/profiles/{userId}/consents" appId="R6 PC e3d5ea9e-…" appHref="/guide/identifiers#app-ids" />

Query used by account.ubisoft.com: `consentIds` (UUIDs joined with `,`), `spaceId`. Send `Ubi-LocaleCode`.

```ts
type ConsentsResponse = {
  consents: {
    [consentId: string]: { consentValue: ConsentVisibility }
  }
}
```

---

## Set consents (v2) {#set-v2}

<Endpoint method="PATCH" path="/v2/profiles/{userId}/consents" appId="R6 PC e3d5ea9e-…" appHref="/guide/identifiers#app-ids" />

```ts
type ConsentPatchV2 = {
  consents: {
    [consentId: string]: { consentValue: ConsentVisibility }
  }
}
```

Exact body from the official-site client:

```json
{
  "consents": {
    "8f31dfaa-325e-4bb6-8e2b-cd8405e10fa3": { "consentValue": "private" }
  }
}
```

`200` or `204`. `{userId}` is yours. Header casing `Ubi-appid` works. Login hop is Connect `f68a4bb5-…` then [exchange](/guide/ticket-exchange) to `e3d5ea9e-…`.

<Endpoint method="GET" path="/v2/spaces/configs/consents?consentIds=&profileId=" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Consent catalogue (labels, not values). Query: `consentIds` (comma-separated), optional `profileId`.

The account.ubisoft.com dump also shows a PATCH body of `{ "consents": [ ... ] }` (array). The live privacy client sends the object form above; both are documented from clients.

---

## Read a v1 category {#read-friends}

<Endpoint method="GET" path="/v1/profiles/{userId}/consents/categories/friends" appId="R6 PC e3d5ea9e-…" appHref="/guide/identifiers#app-ids" />

One category by **key**. Swap `friends` for any key in [the table](#keys).

---

## Set a v1 category {#set-category}

<Endpoint method="PATCH" path="/v1/profiles/{userId}/consents/categories/{consentKey}" appId="R6 PC e3d5ea9e-…" appHref="/guide/identifiers#app-ids" />

Prefer [v2](#set-v2). Value is still `public` / `friendsOnly` / `private`.
