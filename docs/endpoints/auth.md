# Auth & session

How to obtain a [`Session`](/guide/common-types#session). Read [Authentication](/guide/authentication) first; this page is the HTTP contract.

## Create session {#create-session}

<Endpoint method="POST" path="/v3/profiles/sessions" auth="basic-or-ticket" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Two modes, same URL:

| Mode | `Authorization` | Result |
|---|---|---|
| Password login | `Basic {base64(email:password)}` | New session for this `Ubi-AppId` |
| [Complete 2FA](/guide/authentication#complete-2fa) | `Ubi_2fa_v1 t={twoFactorAuthenticationTicket}` | Full session after `ubi-2facode` |
| [Ticket exchange](/guide/ticket-exchange) | `ubi_v1 t={ticket}` | New session for a **different** `Ubi-AppId` |

### Headers

[Standard headers](/guide/headers). For password login, replace `Authorization` with Basic and you may omit `Ubi-SessionId`. For 2FA completion, add `ubi-2facode`.

### Body

```ts
type CreateSessionBody = {
  rememberMe?: boolean
  trustedDevice?: null
}
```

Empty `{}` is accepted. `rememberMe: true` is what yields `rememberMeTicket` on success. 2FA completion uses `{ trustedDevice: null }` or `{ rememberMe: true }`.

### Response

[`Session`](/guide/common-types#session).

::: warning 2FA ticket is not a full ticket
HTTP **200** with `ticket: null` and a populated `twoFactorAuthenticationTicket` means 2FA is enabled. That 2FA ticket is usable as `Authorization: ubi_v1 t={twoFactorAuthenticationTicket}`, but it has **limited scope and access** compared to a real `ticket`. Details: [Two-factor](/guide/authentication#two-factor).
:::

### Notes

- First login almost always uses [Main Auth](/guide/identifiers#app-ids) `4391c956-8943-48eb-8859-07b0778f47b9`.
- Alternate login app ID: `503a4b49-12c9-47b9-b26d-6a1a7e38c08c`.
- Response includes `userId`, `nameOnPlatform`, `dateOfBirth`, `rememberMeTicket`, and 2FA-related fields.

## 2FA status {#2fa-status}

<Endpoint method="GET" path="/v3/profiles/me/2fa" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Current two-factor configuration for the authenticated user (enabled or not). Needs a full `ticket`, not a 2FA ticket.

### Headers

[Standard headers](/guide/headers).

### Response

Shape varies by whether 2FA is enabled. Treat it as a status payload, not a session.

Setup / disable: [Account → 2FA](/endpoints/account#two-factor-setup).

## Connect 2FA check {#connect-check-2fa}

<Endpoint method="GET" path="/v2/webauth/public/webauth/check2fa" host="connect" auth="sso" appId="Connect website 314d4fef-…" appHref="/guide/identifiers#app-ids" />

Alternate 2FA status check used by **Ubisoft Connect website**, on the [Connect host](/guide/environments). Requires the website's SSO cookies, not a raw `ubi_v1` ticket.

Related cookie flow: [Cross-channel SSO](/endpoints/sso).
