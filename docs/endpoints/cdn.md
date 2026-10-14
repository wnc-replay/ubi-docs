# CDN, CMS & Algolia

CDN and search endpoints need no ticket. The [Connect avatar API](#avatar-api) below is authenticated.

## Avatars {#avatars}

```
https://ubisoft-avatars.akamaized.net/{profileId}/default_146_146.png
```

`profileId` is the uplay (or other) profile UUID from [linked profiles](/endpoints/user#linked-profiles). Other sizes exist (`default_256_256`, …) but `146` is the one every official web surface uses.

Avatar **visibility** to other users is the [`avatar` consent](/endpoints/consent).

## Avatar API (Connect) {#avatar-api}

These are on **`connect.ubisoft.com`**, not the Akamai CDN. Ticket + session headers as usual.

<Endpoint method="GET" path="/v1/profiles/{profileId}/avatars" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/profiles/avatars?profileIds=" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

`profileIds` is comma-separated.

<Endpoint method="GET" path="/v1/spaces/configs/avatars" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/spaces/avatars/galleries" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Also `GET /v1/spaces/avatars/galleries/{galleryId}`.

<Endpoint method="POST" path="/v1/profiles/{profileId}/avatars/galleries" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "galleryAvatarId": "{avatarId}" }`.

<Endpoint method="GET" path="/profiles/{profileId}/covers" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/spaces/covers/galleries" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

---

## Algolia {#algolia}

Site search indexes (news / help / store). Search keys are not published in this documentation.

| Env | Host | App ID | Search key |
|---|---|---|---|
| PROD | `https://avcvysejs1-dsn.algolia.net/1/indexes/...` | `avcvysejs1` | Not published |
| UAT | `https://uktqrz7nxh-dsn.algolia.net/1/indexes/...` | `UKTQRZ7NXH` | Not published |
| Dev | `https://akjpspznz2-dsn.algolia.net/1/indexes/...` | `AKJPSPZNZ2` | Not published |

Use Algolia's normal `X-Algolia-Application-Id` / `X-Algolia-API-Key` headers.

## CMS cache {#cms}

```
https://cms-cache.ubisoft.com/cdn/spaces/{spaceId}/environments/{env}/entries?...
```

`spaceId` can be a CMS space (not always the R6 game space). `{env}` is typically `master` / `live`-style. Query string is Contentful-like (`content_type`, locale, …).
