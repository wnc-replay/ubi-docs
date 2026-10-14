# Applications & spaces

Resolve an **app ID** or **space ID** to a name. Useful when [action logs](/endpoints/user#action-log) or [presence](/endpoints/presence) only give you UUIDs. Known constants: [Identifiers](/guide/identifiers).

## List applications {#list-applications}

<Endpoint method="GET" path="/v1/applications" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Full application catalogue. Large. Cache it.

## Application by ID {#application-by-id}

<Endpoint method="GET" path="/v1/applications/{appId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

One application: name, platform, associated `spaceId`.

`{appId}` is any value from the [app ID table](/guide/identifiers#app-ids) (or from presence / action log).

## Space by ID {#space-by-id}

<Endpoint method="GET" path="/v1/spaces/{spaceId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Space details: name, type, parent title, tags.

Rainbow Six Siege primary space: `0d2ae42d-4c27-4cb7-af6c-2099062302bb` — [space IDs](/guide/identifiers#space-ids).

---

## Connect game catalog {#connect-catalog}

Used by account.ubisoft.com (`connectClient`). Host is **Connect**.

<Endpoint method="GET" path="/v1/spaces/global/ubiconnect/games/api/catalog" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Query: `spaceIds` (comma-separated), `offset`, `limit`, `defaultOnly`. Send `Ubi-LocaleCode`.

---

## MDM products {#mdm-products}

<Endpoint method="GET" path="/v1/mdm/products" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Query: `referentialIds` (comma-separated), `referentialType`, `productTypeKeys`. Send `Ubi-LocaleCode`.

---

## Space news {#space-news}

<Endpoint method="GET" path="/v1/spaces/news?spaceId={spaceId}" appId="Connect website 314d4fef-…" appHref="/guide/identifiers#app-ids" />

Free-games / carousel feed. Query: `spaceId` (required), optional `placement` (`carousel`), `limit`, `locale`.

Seen spaces: [free-games](/guide/identifiers#space-ids) `6d0af36b-…`, [Connect carousel](/guide/identifiers#space-ids) `66fcdb38-…`. `Ubi-AppId` + `Ubi-LocaleCode` are enough on the public free.ubisoft.com call.
