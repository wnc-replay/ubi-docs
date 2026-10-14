# Inventory & offers (R6 Siege)

PC Rainbow Six Siege inventory, catalogues, offer redeem, and clearance level.

- **spaceId:** [R6 primary](/guide/identifiers#space-ids) `0d2ae42d-4c27-4cb7-af6c-2099062302bb`
- **Currencies:** [item IDs](/guide/identifiers#item-ids)
- **Catalogues:** [compressed payloads](/guide/compressed-payloads)

[Headers](/guide/headers) are standard. Inventory worker app ID `3587dcbb-…` is used by some official jobs; a main-auth or R6 PC ticket is what most clients send after [exchange](/guide/ticket-exchange).

---

## Inventory {#inventory}

<Endpoint method="GET" path="/v1/profiles/{userId}/inventory?spaceId={spaceId}&offset=0&limit=10000" appId="Inventory worker 3587dcbb-… or Main Auth" appHref="/guide/identifiers#app-ids" />

Full inventory: skins, charms, currencies.

### Query

| Name | Notes |
|---|---|
| `spaceId` | R6 primary space |
| `offset` | `0` then next page |
| `limit` | Practical max ~`10000`. If `items.length` hits the limit, paginate |

`{userId}` is the Ubisoft user / profile UUID you are allowed to read (usually your own).

### Response

[`InventoryResponse`](/guide/common-types#inventory-item):

```ts
{ items: Array<{ itemId: string; quantity?: number }> }
```

Cosmetics **omit** `quantity`. Currencies **have** it. Pull Renown / R6 Credits / Level by the [known item IDs](/guide/identifiers#item-ids).

To name items, join `itemId` against the [item catalogue](#item-catalogue).

---

## Redeem offer {#redeem-offer}

<Endpoint method="POST" path="/v1/profiles/{profileId}/inventory" appId="Inventory worker 3587dcbb-…" appHref="/guide/identifiers#app-ids" />

Redeem an offer into the profile inventory (in-game unlock / grant). `offerId` comes from the [offer catalogue](#full-offer-catalogue).

### Body

```ts
type RedeemOfferBody = {
  spaceid: string // note: lowercase "i"
  offerId: string
}
```

```json
{
  "spaceid": "0d2ae42d-4c27-4cb7-af6c-2099062302bb",
  "offerId": "{offerId}"
}
```

Only redeem offers the account is entitled to. Failed redeems return `400` / `409` rather than a silent no-op. Response body was not in the dumps.

---

## Offer catalogue {#offer-catalogue}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/offers" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Compressed offer catalogue (smaller / filtered vs `/all`).

Decode: [compressed payloads](/guide/compressed-payloads).

---

## Full offer catalogue {#full-offer-catalogue}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/offers/all" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

### Response (outer)

```ts
type CompressedOffersResponse = {
  compressedOffers: string // base64 gzip
}
```

Inner JSON has an `.items` (or equivalent offers) array including `offerId` used by [redeem](#redeem-offer).

---

## Item catalogue {#item-catalogue}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/items/all" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

### Response (outer)

```ts
type CompressedItemsResponse = {
  compressedItems: string // base64 gzip
}
```

After decode, each row is a [`CatalogueItem`](/guide/common-types#catalogue-item): `itemId`, `name`, `tags[]`, `item_type`.

```ts
zlib.gunzipSync(Buffer.from(res.compressedItems, 'base64'))
```

Cache this. It is a patch-sized blob, not a per-user blob.

---

## Clearance level {#clearance-level}

<Endpoint method="GET" path="/v1/profiles/stats?spaceId={spaceId}&statNames=PClearanceLevel&profileIds={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

**Canonical account level** for Siege.

### Query

| Name | Value |
|---|---|
| `spaceId` | R6 primary |
| `statNames` | `PClearanceLevel` (comma-separate more stats if needed) |
| `profileIds` | Target profile / user UUID |

### Response

```ts
type StatsResponse = {
  profiles: Array<{
    profileId: string
    stats: {
      PClearanceLevel: { value: number }
    }
  }>
}
```

Read `profiles[].stats.PClearanceLevel.value`. Prefer this over the inventory Level item or the legacy rewards URL.

---

## Legacy public profile rewards {#legacy-rewards}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/title/r6s/rewards/public_profile?profile_id={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Level + XP. **Hit/miss** — do not use as the canonical level. Use [`PClearanceLevel`](#clearance-level).
