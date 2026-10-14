# GraphQL

Marketplace, some privilege checks, and party invites share **one** HTTP endpoint:

[`POST /v1/profiles/me/uplay/graphql`](/endpoints/marketplace)

The official Connect client sends **persisted queries**: `operationName` + `variables` + the SHA-256 of the stored query. The same route also accepts the GraphQL `query` source in place of the hash.

## Request body

```ts
type PersistedQuery = {
  operationName: string
  variables: Record<string, unknown>
  query?: string // accepted instead of the hash
  extensions?: {
    persistedQuery: {
      version: 1
      sha256Hash: string
    }
  }
}
```

Send **either** `extensions.persistedQuery` **or** `query`. Connect PC sometimes POSTs an **array** of these objects instead of a single object; the response is then an array too.

Use [standard headers](/guide/headers) with a [marketplace](/guide/identifiers#app-ids) (or party) ticket from [ticket exchange](/guide/ticket-exchange).

## Known operations

Full variable notes live on [Marketplace](/endpoints/marketplace). Known hashes:

| Operation | Purpose | `sha256Hash` |
|---|---|---|
| `GetTradeLimitations` | Buy/sell caps + resale locks | — |
| `GetBalance` | Account credits (`secondaryStoreItem.meta.quantity`) | — |
| `GetSellableItems` | Marketable items + ownership | — |
| `CreateBuyOrder` | Place a buy order | — |
| `CreateSellOrder` | Place a sell order | — |
| `CancelOrderMutation` | Cancel an active order | — |
| `GetTransactionsPending` | Pending orders (`Created`) | — |
| `GetTransactionsHistory` | Completed / cancelled (`Succeeded`, `Failed`) | — |
| `GetItemDetails` | Item + market data + payment limits | — |
| `GetItemPriceHistory` | Daily price points | — |
| `GetMarketableItems` | Catalog search | — |
| `GetMarketplaceGameConfig` | Tags, types, currency, privilege | — |
| `SendPartyInvitationMutation` | Party invite | `a9518dd087c353117145dd0d95e5e4f344210ca012f4e0c834c65bb972faceaf` |
| `GetViewerParties` | Caller's parties | `3ab6d8d776f06300fc4748780e3ab4d7fa4807701e2d11d9b2d303d00cd855f1` |
| `SendFriendRequestMutation` | Friend request | `bc99fe5882c985b64a8f3105cdd8cf99f58141e4b9a5a1b945ea1c3e3236c662` |
| `GetMultipleUserProfiles` | Profile cards + linked networks | — |
| `GetPlayerPrivilege` | Ban / privilege check | — |

Party / friend ops need the [party app ID](/guide/identifiers#app-ids) `0a0379c0-…`. Marketplace ops need the marketplace app IDs. Variables and response paths are on [Marketplace](/endpoints/marketplace).

## Pending vs history

`GetTransactionsPending` filters `states: [Created]`. `GetTransactionsHistory` filters `states: [Succeeded, Failed]`. Same `trades` field.
