# Ticket exchange

A Ubisoft **ticket is scoped to an application**. The client logs in once (usually with [main auth](/guide/identifiers#app-ids)), then re-posts the same sessions endpoint with the existing **full** `ticket` and a **different** `Ubi-AppId`. The response is a new [`Session`](/guide/common-types#session) whose `ticket` / `sessionId` are valid for that app.

[2FA tickets](/guide/authentication#two-factor) are not full tickets — they do not substitute here.

This is how marketplace, support cases, inventory workers, and R6 PC consent all sit on one account without a second password prompt.

## Request

Same path as [create session](/endpoints/auth#create-session):

```http
POST https://public-ubiservices.ubi.com/v3/profiles/sessions
Authorization: ubi_v1 t={existingTicket}
Ubi-AppId: {targetAppId}
Ubi-SessionId: {existingSessionId}
Ubi-RequestedPlatformType: uplay
Content-Type: application/json
```

Body is typically `{}`.

Use the **new** `ticket` and `sessionId` on subsequent calls. Keep the original ticket if you still need the original app.

## Which app ID to exchange to

Full table: [App IDs](/guide/identifiers#app-ids). Practical mapping:

| You want to call… | Exchange to |
|---|---|
| General profile / friends / presence | Main Auth `4391c956-…` (no exchange if you already logged in with it) |
| [Consent PATCH](/endpoints/consent) (R6 PC scope) | `e3d5ea9e-50bd-43b7-88bf-39794f4e3d40` (login hop often `f68a4bb5-…`) |
| [Support cases](/endpoints/support) | Main Auth `4391c956-…` as a **third** session (cases are picky) |
| [Marketplace GraphQL](/endpoints/marketplace) | Marketplace auth `aa88e512-…`, then ops `804a4e08-…` as needed |
| [Account.ubisoft.com](/endpoints/account) flows | `afb4b43c-…` or website `74e71609-…` |
| [Bug reporter](/endpoints/bug-reporter) | `d5fa0769-…` |
| Party GraphQL | `0a0379c0-…` |
| Inventory worker | `3587dcbb-…` |
| IP location | `4008612d-…` |

::: tip Consent
[Consent toggle](/endpoints/consent) only sticks if you exchange to the R6 Siege PC app ID `e3d5ea9e-…` **before** the `PATCH`. A main-auth ticket is not enough.
:::

## Typical client sequence

1. Password (or remember-me) login with **Main Auth**.
2. `GET /v3/users/me` with that ticket — cache `userId`.
3. For each specialized surface, exchange once and cache `{ appId → session }`.
4. When a call returns `401` / expired ticket, exchange again from the still-valid main ticket. If the main ticket is dead, password login.

There is no documented global refresh-token endpoint on ubi-services besides `rememberMeTicket` and the [Connect SSO refresh](/endpoints/sso) routes used by the website.
