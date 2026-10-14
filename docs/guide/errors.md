# Errors

Ubisoft does not publish a stable error catalogue. These are the patterns you will actually hit.

## HTTP statuses

| Status | Typical meaning |
|---|---|
| `200` | Success. Inspect the body: a 2FA login returns 200 with a limited-scope [`twoFactorAuthenticationTicket`](/guide/authentication#two-factor) instead of a full `ticket`. |
| `201` | Created (bug-reporter contributions / issues) |
| `204` | Empty success (unlinks, upvotes, some consent PATCHes) |
| `400` | Bad JSON, missing `spaceId`, invalid offer, username failing validation, contribution limit |
| `401` | Missing/expired ticket, or ticket minted for a **different** `Ubi-AppId` |
| `403` | Authenticated but not allowed (ban, consent, wrong user, missing privilege) |
| `404` | Unknown profile / case / space |
| `409` | Conflict (name taken, already linked, offer not redeemable) |
| `429` | Rate limited — `errorCode` `1101` is “too many calls per IP” |
| `5xx` | Ubisoft-side. Retry with jitter; catalogues especially |

## Ticket vs app ID

The #1 client bug is `401` because you reused a main-auth ticket against marketplace, cases, or consent. [Exchange](/guide/ticket-exchange) first.

## Body shape

Error bodies vary by generation of the API (`v1` vs `v3`, GraphQL vs REST). Common fields:

```ts
type UbiError = {
  httpCode?: number
  errorCode?: number | string
  message?: string
  moreInfo?: string
  stackTrace?: string
}
```

Account-site `errorCode` values: `3` expired, `4` not allowed, `7` not found, `1022` invalid SMS code, `1031` child count limit, `1032` guardian under age, `1053` invalid guardian token, `1213` username locked, `1301` reCAPTCHA challenge, `1307` invalid authenticator code, `1310` invalid email code.

GraphQL errors sit in the usual `{ data, errors[] }` envelope even when HTTP is 200. `errors[].extensions.code` `1853` on `CancelOrderMutation` means the order is already gone.

## Pagination

Inventory `limit` around `10000` is a practical max. If `items.length` equals the limit, request the next `offset`. Don't assume a single page.

## Compression failures

If catalogue JSON parse throws, you skipped [gzip after Base64](/guide/compressed-payloads). The outer HTTP body is valid JSON; only the inner field is compressed.
