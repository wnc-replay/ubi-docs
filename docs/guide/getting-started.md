# Getting started

The fastest way to learn this API is to make one session, then one authenticated `GET`. Everything else is the same pattern with a different path, [app ID](/guide/identifiers#app-ids), or [ticket exchange](/guide/ticket-exchange).

## 1. Pick a host

Production is what almost every tool uses:

| Role | Host |
|---|---|
| Almost all REST | `https://public-ubiservices.ubi.com` |
| Web SSO / Connect | `https://connect.ubisoft.com` |
| Account ecom (USS / SCS / ESS) | See [Environments → Ecommerce](/guide/environments#ecommerce) |

Other environments live on [Environments](/guide/environments).

## 2. Create a session

`POST /v3/profiles/sessions` with [Basic auth](/guide/authentication#password-login) and the [main auth app ID](/guide/identifiers#app-ids).

```http
POST https://public-ubiservices.ubi.com/v3/profiles/sessions
Authorization: Basic {base64(email:password)}
Ubi-AppId: 4391c956-8943-48eb-8859-07b0778f47b9
Ubi-RequestedPlatformType: uplay
Content-Type: application/json
```

A JSON body is typically `{}` or `{ "rememberMe": true }`.

Read the response as a [`Session`](/guide/common-types#session). **Do not treat HTTP 200 as a full login.** If `ticket` is `null` and `twoFactorAuthenticationTicket` is set, you have a [limited-scope 2FA ticket](/guide/authentication#2fa-ticket), or you can [complete 2FA](/guide/authentication#complete-2fa) with `Ubi_2fa_v1` + `ubi-2facode` to get a real `ticket`.

## 3. Call anything else with the ticket

```http
GET https://public-ubiservices.ubi.com/v3/users/me
Authorization: ubi_v1 t={ticket}
Ubi-AppId: 4391c956-8943-48eb-8859-07b0778f47b9
Ubi-SessionId: {sessionId}
Ubi-RequestedPlatformType: uplay
Ubi-LocaleCode: en-US
Content-Type: application/json
```

That header set is defined once on [Headers](/guide/headers). Endpoint pages only mention extras.

## 4. Exchange the ticket when the app ID changes

A ticket is **scoped to the `Ubi-AppId` that created it**. Marketplace, support cases, R6 PC consent, and several other surfaces need a different app ID. Re-`POST` the same sessions path with `Authorization: ubi_v1 t={ticket}` and the new app ID — see [Ticket exchange](/guide/ticket-exchange).

## Suggested first reads

1. [Authentication](/guide/authentication) — password, 2FA tickets, ticket lifetime
2. [User & profile](/endpoints/user) — `/v3/users/me`, linked platforms
3. [Inventory](/endpoints/inventory) or [Stats](/endpoints/stats) if you are building R6 tools
4. [GraphQL](/guide/graphql) if you are touching the marketplace

## Tooling

Any REST client works (Insomnia, Bruno, REST Client, curl). There is no official SDK. Generate code from a saved request once you have a ticket; don't hard-code passwords in source.
