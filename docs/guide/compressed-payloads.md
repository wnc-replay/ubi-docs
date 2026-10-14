# Compressed payloads

Offer and item catalogues are **not** plain JSON. The HTTP body is JSON with a Base64 field that is a gzip of the real payload.

Applies to:

- [`GET /v1/spaces/{spaceId}/items/all`](/endpoints/inventory#item-catalogue) → `compressedItems`
- [`GET /v1/spaces/{spaceId}/offers/all`](/endpoints/inventory#full-offer-catalogue) → `compressedOffers`
- [`GET /v1/spaces/{spaceId}/offers`](/endpoints/inventory#offer-catalogue) (also compressed)

## Decode

```ts
import { gunzipSync } from 'node:zlib'

function decodeCatalogue(b64: string) {
  const json = gunzipSync(Buffer.from(b64, 'base64')).toString('utf8')
  const parsed = JSON.parse(json)
  return parsed.items // catalogue arrays live under .items
}
```

Python equivalent: `gzip.decompress(base64.b64decode(b64))` then `json.loads`.

## After decode

Each item is a [`CatalogueItem`](/guide/common-types#catalogue-item): `itemId`, `name`, `tags[]`, `item_type`.

Offers decode to a list of offer objects keyed by `offerId` (used when [redeeming](/endpoints/inventory#redeem-offer)). Keep a map `itemId → name` if you are labelling inventory.

Catalogues are large. Cache them (they change on patches, not per request) and do not fetch `/all` on every user lookup.
