# Bug reporter

Rainbow Six Siege public bug reporter (`www.ubisoft.com/.../bug-reporter`). Host is **not** ubi-services:

`https://prod-api-bugreporter.ubisoft.com/public`

Auth is still a ubi-services [ticket](/guide/authentication#ticket). [Exchange](/guide/ticket-exchange) (or log in) with a bug-reporter [app ID](/guide/identifiers#app-ids). Official pages also send `Origin: https://www.ubisoft.com`.

| ID | Role |
|---|---|
| `d5fa0769-5139-4671-8f83-3479176edafd` | Current web client |
| `f6214bf2-584f-47c2-ab4e-c6b1e8375925` | Earlier web client |
| `7f166d62-3f97-4ab7-a460-6c33f8a6875e` | R6 installment (in the path, not `Ubi-AppId`) |

There are two issue identifiers:

| Kind | Example | Used for |
|---|---|---|
| Public key | `R6S-49` | Display, [upvote](#upvote) |
| Internal id | `123520` | [Contribute](#contribute), [create](#create-issue) response |

---

## List issues {#list-issues}

<Endpoint method="GET" path="/public/v2/installments/{installmentId}/issues?pageSize=16&pageNumber=1&isPrivate=false&orderBy=7" host="bugreporter" appId="Bug reporter d5fa0769-…" appHref="/guide/identifiers#app-ids" />

### Query

| Name | Notes |
|---|---|
| `pageSize` | 1–100 |
| `pageNumber` | 1-based |
| `isPrivate` | `false` for the public board |
| `orderBy` | `7` is the live site default |
| `search` | Optional title/description search |

### Response

```ts
type IssueList = {
  items: Array<{
    id: number
    key?: string | number
    fullKey?: string // e.g. "R6S-49"
    title?: string
    status?: { name: string }
    totalNumberOfContributions?: number
  }>
  totalCount: number
}
```

---

## Create issue {#create-issue}

<Endpoint method="POST" path="/public/v1/installments/{installmentId}/issues" host="bugreporter" appId="Bug reporter d5fa0769-…" appHref="/guide/identifiers#app-ids" />

```ts
type CreateIssueBody = {
  title: string
  titles: string[] // platform title UUIDs, see below
  description: string
  categories: number[]
  frequencyId: number
  stepsToReproduce: string
  workaround: string
  urls: string[]
  assetsUploadRequestId: string // fresh UUID
  attachmentAssets: unknown[]
}
```

`201` with `id` (internal) and `fullKey` / `key` (public).

### Platform title IDs {#platform-titles}

| Platform | Title ID |
|---|---|
| PC | `f3a64053-dd23-419f-845d-4c35eccf7bf3` |
| PS4 | `fd79999d-a764-42a5-b162-3fdd62796fa6` |
| PS5 | `26133c7a-6163-427d-985b-0a2ea26f413a` |
| Xbox One | `4f55417f-bdf7-4cdc-b19e-2d5f34b7fa01` |
| Xbox Series S | `114c269d-a49f-4f76-b7e5-b22fff0f50e0` |
| Xbox Series X | `4bd0d0a4-19e8-4985-8b74-567687ed924e` |
| GeForce Now | `9e5cb90d-42d0-406e-9bbd-633abeddb3cd` |

---

## Contribute {#contribute}

<Endpoint method="POST" path="/public/v1/installments/{installmentId}/issues/{issueId}/contributions" host="bugreporter" appId="Bug reporter d5fa0769-…" appHref="/guide/identifiers#app-ids" />

`{issueId}` is the **internal** numeric id.

```ts
type ContributionBody = {
  description: string
  titleIds: string[]
  specificationIds: string[]
  urls: string[]
  attachmentAssets: unknown[]
  assetsUploadRequestId: string
}
```

`201` with contribution `id`. One contribution per account per issue — a second POST returns `400`.

---

## Upvote {#upvote}

<Endpoint method="PUT" path="/public/v1/installments/{installmentId}/issues/{publicNumber}/ratings" host="bugreporter" appId="Bug reporter d5fa0769-…" appHref="/guide/identifiers#app-ids" />

Empty body. `{publicNumber}` is the numeric part of `R6S-49` (`49`), not the internal id. `204` on success. This call often omits `Ubi-SessionId`.
