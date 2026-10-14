# Marketplace & party GraphQL

**Single HTTP route.** Operations are [persisted queries](/guide/graphql). Send `operationName` + `variables` + either `extensions.persistedQuery.sha256Hash` or the `query` source. Body may be one object or an **array** of those objects; an array comes back as an array.

<Endpoint method="POST" path="/v1/profiles/me/uplay/graphql" appId="Marketplace auth aa88e512-… / ops 804a4e08-… / party 0a0379c0-…" appHref="/guide/identifiers#app-ids" />

### Headers

[Standard headers](/guide/headers). [Exchange](/guide/ticket-exchange) to:

| Surface | App ID |
|---|---|
| Marketplace auth | `aa88e512-9395-457d-bcb9-8d59c23f88c9` |
| Marketplace ops | `804a4e08-8797-44f0-8fce-eabe8f7f0dda` |
| Marketplace alt | `685a3038-2b04-47ee-9c5a-6403381a46aa` |
| Parties / friend requests | `0a0379c0-c673-4183-bf32-48e72f9dc91f` |

Connect PC also sends `ubi-profileid`, `x-platform-appid: 83564d31-7cd7-4bc0-a763-6524e78d1a7f`, `Origin: https://connect.cdn.ubisoft.com`, `apollographql-client-version: 1.56.1`.

Marketplace credits use the [R6 Credits item](/guide/identifiers#item-ids) `9ef71262-515b-46e8-b9a8-b6b6ad456c67`. Space is [R6 primary](/guide/identifiers#space-ids).

### Body

[`PersistedQuery`](/guide/graphql#request-body).

Official Connect clients send the hash. Other clients send the GraphQL `query` string with the same `operationName` and `variables`. Marketplace trade hashes were not in the dumps; the **variables and selection sets** below are.

---

## GetTradeLimitations {#get-trade-limitations}

Buy/sell caps and resale locks for the viewer.

```ts
type GetTradeLimitationsVariables = {
  spaceId: string
}
```

```ts
type GetTradeLimitationsData = {
  game: {
    viewer: {
      meta: {
        tradesLimitations: {
          buy: {
            resolvedTransactionCount: number
            resolvedTransactionPeriodInMinutes: number
            activeTransactionCount: number
          }
          sell: {
            resolvedTransactionCount: number
            resolvedTransactionPeriodInMinutes: number
            activeTransactionCount: number
            resaleLocks: Array<{ itemId: string; expiresAt: string }>
          }
        }
      }
    }
  }
}
```

---

## GetBalance {#get-balance}

Marketplace credits (or any secondary-store item) for the viewer.

```ts
type GetBalanceVariables = {
  spaceId: string
  itemId: string // R6 Credits: 9ef71262-515b-46e8-b9a8-b6b6ad456c67
}
```

```json
{
  "operationName": "GetBalance",
  "variables": {
    "spaceId": "0d2ae42d-4c27-4cb7-af6c-2099062302bb",
    "itemId": "9ef71262-515b-46e8-b9a8-b6b6ad456c67"
  }
}
```

```ts
type GetBalanceData = {
  game: {
    viewer: {
      meta: {
        secondaryStoreItem: {
          meta: { id: string; quantity: number }
        }
      }
    }
  }
}
```

When the request is an array of one operation, the HTTP body is `[{ data: GetBalanceData }]`.

Trade objects reused below:

```ts
type Trade = {
  id: string
  tradeId: string
  state: string // Created | Succeeded | Failed
  category?: string
  createdAt?: string
  expiresAt?: string
  lastModifiedAt?: string
  failures?: unknown
  tradeItems: Array<{ item: { itemId: string; name: string; tags: string[]; type: string } }>
  payment?: { price: number; transactionFee: number }
  paymentOptions?: Array<{ price: number; transactionFee: number }>
  paymentProposal?: { price: number }
}
```

---

## GetSellableItems {#get-sellable-items}

Items the account can list, plus ownership and market stats. Join `itemId` against the [item catalogue](/endpoints/inventory#item-catalogue) if you need names.

```ts
type GetSellableItemsVariables = {
  spaceId: string
  limit: number
  offset?: number
  filterBy?: { types?: string[]; tags?: string[] | string[][]; text?: string }
  withOwnership?: boolean
  sortBy?: {
    field: 'ACTIVE_COUNT' | string
    orderType: 'Sell' | 'Buy' | string
    direction: 'ASC' | 'DESC'
    paymentItemId: string
  }
}
```

```ts
type GetSellableItemsData = {
  game: {
    viewer: {
      meta: {
        marketableItems: {
          totalCount: number
          nodes: Array<{
            item: {
              itemId: string
              name: string
              tags: string[]
              type: string
              assetUrl?: string
              viewer?: { meta: { isOwned: boolean; quantity: number } }
            }
            marketData: {
              sellStats: Array<{
                paymentItemId: string
                lowestPrice: number
                highestPrice: number
                activeCount: number
              }>
              buyStats: Array<{
                paymentItemId: string
                lowestPrice: number
                highestPrice: number
                activeCount: number
              }>
              lastSoldAt?: {
                paymentItemId: string
                price: number
                performedAt: string
              }
            }
            viewer?: { meta: { activeTrade?: { tradeId: string; state: string } } }
          }>
        }
      }
    }
  }
}
```

---

## CreateBuyOrder {#create-buy-order}

Place a buy order. Some clients name this `CreateBuyOrderMutation`.

```ts
type CreateBuyOrderVariables = {
  spaceId: string
  tradeItems: Array<{ itemId: string; quantity: number }>
  paymentProposal: { paymentItemId: string; price: number }
}
```

```ts
type CreateBuyOrderData = {
  createBuyOrder: {
    trade: {
      id: string
      tradeId: string
      state: string
      paymentProposal: {
        price: number
        item: { viewer: { meta: { quantity: number } } }
      }
    }
  }
}
```

`paymentProposal.item.viewer.meta.quantity` is remaining credits after the order.

---

## CreateSellOrder {#create-sell-order}

Place a sell order. Some clients name this `CreateSellOrderMutation`.

```ts
type CreateSellOrderVariables = {
  spaceId: string
  tradeItems: Array<{ itemId: string; quantity: number }>
  paymentOptions: Array<{ paymentItemId: string; price: number }>
}
```

```ts
type CreateSellOrderData = {
  createSellOrder: {
    trade: {
      id: string
      tradeId: string
      state: string
      paymentOptions: Array<{
        price: number
        transactionFee: number
        item: { viewer: { meta: { quantity: number } } }
      }>
    }
  }
}
```

---

## CancelOrderMutation {#cancel-order}

Cancel an active order by the `tradeId` returned from pending / create.

```ts
type CancelOrderVariables = {
  spaceId: string
  tradeId: string
}
```

```ts
type CancelOrderData = {
  cancelOrder: {
    trade: { id: string; tradeId: string; state: string }
  }
}
```

GraphQL `errors[].extensions.code` `1853` means the order is already gone.

---

## GetTransactionsPending {#get-transactions-pending}

Active / pending orders. Filter is `states: [Created]`.

```ts
type GetTransactionsPendingVariables = {
  spaceId: string
  limit: number
  offset: number
}
```

```ts
type GetTransactionsPendingData = {
  game: { viewer: { meta: { trades: { nodes: Trade[] } } } }
}
```

---

## GetTransactionsHistory {#get-transactions-history}

Completed and cancelled orders. Same `trades` field as pending, with `filterBy: { states: [Succeeded, Failed] }` and `sortBy: { field: LAST_MODIFIED_AT }`.

```ts
type GetTransactionsHistoryVariables = {
  spaceId: string
  limit: number
  offset: number
}
```

```ts
type GetTransactionsHistoryData = {
  game: { viewer: { meta: { trades: { nodes: Trade[] } } } }
}
```

`Succeeded` = filled. `Failed` = cancelled / expired in the clients that use this.

---

## GetItemDetails {#get-item-details}

Full item card: ownership, market stats, payment limits, and the viewer's active trades on that item.

```ts
type GetItemDetailsVariables = {
  spaceId: string
  itemId: string
  tradeId: string // empty string when not fetching one trade
  fetchTrade: boolean
}
```

```ts
type GetItemDetailsData = {
  game: {
    marketableItem: {
      item: { itemId: string; name: string; tags: string[]; type: string; assetUrl?: string }
      marketData: {
        sellStats: Array<{ paymentItemId: string; lowestPrice: number; highestPrice: number; activeCount: number }>
        buyStats: Array<{ paymentItemId: string; lowestPrice: number; highestPrice: number; activeCount: number }>
        lastSoldAt?: { paymentItemId: string; price: number; performedAt: string }
      }
      paymentLimitations: Array<{ paymentItemId: string; minPrice: number; maxPrice: number }>
    }
    viewer: {
      meta: {
        trades: { nodes: Trade[] }
        trade?: Trade // only if fetchTrade
      }
    }
  }
}
```

A thinner client query only reads `secondaryStoreItem.meta.name` with `{ spaceId, itemId }`.

---

## GetItemPriceHistory {#get-item-price-history}

Daily price points for an item in one payment currency.

```ts
type GetItemPriceHistoryVariables = {
  spaceId: string
  itemId: string
  paymentItemId: string // R6 Credits: 9ef71262-…
}
```

```ts
type GetItemPriceHistoryData = {
  game: {
    marketableItem: {
      priceHistory: Array<{
        date: string
        lowestPrice: number
        averagePrice: number
        highestPrice: number
        itemsCount: number
      }>
    }
  }
}
```

---

## GetMarketableItems {#get-marketable-items}

Catalog search (not the viewer's inventory). Same node shape as [`GetSellableItems`](#get-sellable-items), but `marketableItems` hangs off `game` instead of `game.viewer.meta`.

```ts
type GetMarketableItemsVariables = {
  spaceId: string
  limit: number // clients cap around 500
  offset?: number
  withOwnership?: boolean
  filterBy?: {
    types?: string[]
    tags?: string[][]
    text?: string
  }
  sortBy?: {
    field: 'ACTIVE_COUNT' | 'LAST_TRANSACTION_PRICE' | 'DISPLAY_NAME' | string
    direction: 'ASC' | 'DESC'
    orderType?: 'Buy' | 'Sell'
    paymentItemId: string
  }
}
```

`ACTIVE_COUNT` + `orderType: Buy` = most buy orders; `orderType: Sell` = most listings.

---

## GetMarketplaceGameConfig {#get-marketplace-game-config}

Tag groups, item types, default sorts, currency id, and `privilege.tradePrivilegeId`.

```ts
type GetMarketplaceGameConfigVariables = {
  spaceId: string
}
```

```ts
type GetMarketplaceGameConfigData = {
  game: {
    marketplace: {
      privilege: { tradePrivilegeId: string }
      currency: { currencyId: string; currencyUrl?: string }
      tags: Array<{ value: string; displayName: string; color?: string; iconUrl?: string }>
      tagGroups: Array<{ type: string; displayName: string; values: string[] }>
      types: Array<{ value: string; displayName: string; iconUrl?: string }>
      filters: Array<{
        categoryId: string
        type: string
        displayName: string
        sortType?: string
        sortDirection?: string
        values: Array<{ value: string; displayName: string }>
      }>
    }
  }
}
```

Tag group display names seen: `Rarity`, `Esports Team`, `Season`, `Operator`, `Weapon`, `Event`.

---

## SendFriendRequestMutation {#send-friend-request}

Connect PC (`Origin: https://connect.cdn.ubisoft.com`). [Exchange](/guide/ticket-exchange) to the **party** app ID. The official client POSTs an array of one persisted query.

```ts
type SendFriendRequestVariables = {
  userId: string // target Ubisoft user UUID
}
```

**sha256:** `bc99fe5882c985b64a8f3105cdd8cf99f58141e4b9a5a1b945ea1c3e3236c662`

```json
[
  {
    "operationName": "SendFriendRequestMutation",
    "variables": { "userId": "{targetUserId}" },
    "extensions": {
      "persistedQuery": {
        "version": 1,
        "sha256Hash": "bc99fe5882c985b64a8f3105cdd8cf99f58141e4b9a5a1b945ea1c3e3236c662"
      }
    }
  }
]
```

```ts
type SendFriendRequestResponse = {
  data: {
    sendFriendRequest: {
      userId: string
      __typename: 'FriendRequestPayload'
    }
  }
}
```

---

## SendPartyInvitationMutation {#send-party-invitation}

Invite a player to a party. [Exchange](/guide/ticket-exchange) to the **party** app ID.

```ts
type SendPartyInvitationVariables = {
  inviteeProfileId: string
  spaceId: string
  partyId: string
}
```

`partyId` from [`GET /v1/profiles/{userId}/parties`](/endpoints/user#parties).

**sha256:** `a9518dd087c353117145dd0d95e5e4f344210ca012f4e0c834c65bb972faceaf`

---

## GetViewerParties {#get-viewer-parties}

Parties the caller is in.

**sha256:** `3ab6d8d776f06300fc4748780e3ab4d7fa4807701e2d11d9b2d303d00cd855f1`

---

## GetMultipleUserProfiles {#get-multiple-user-profiles}

Connect-style profile cards (avatar, name, level, online status, last / current game, linked networks such as Twitch).

```ts
type GetMultipleUserProfilesVariables = {
  userIds: string[]
}
```

```ts
type GetMultipleUserProfilesData = {
  users: Array<{
    id: string
    userId: string
    avatarUrl: string
    name: string
    level: number
    onlineStatus: string
    games: { totalCount: number }
    lastPlayedGame?: { node: GameNode }
    currentOnlineGame?: { node: GameNode }
    networks: {
      edges: Array<{
        node: { id: string; publicCodeName: string }
        meta: { id: string; name: string }
      }>
    }
  }>
}

type GameNode = {
  id: string
  name: string
  bannerUrl: string
  platform: { id: string; applicationId: string; name: string; type: string }
}
```

Twitch is `networks.edges[]` where `node.publicCodeName === "TWITCH"`; `meta.name` is the Twitch username.

---

## GetPlayerPrivilege {#get-player-privilege}

GraphQL ban / privilege check. REST equivalent: [player privileges](/endpoints/bans#player-privileges).

Returns `viewer.game.meta.privileges[].isGranted`. Selection set was not in the dumps.
