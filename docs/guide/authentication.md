# Authentication

Almost every ubi-services call needs a **ticket** and a **session ID**. Both come from [`POST /v3/profiles/sessions`](/endpoints/auth#create-session). The ticket is *not* a global bearer token — it is bound to the [`Ubi-AppId`](/guide/identifiers#app-ids) used when it was issued. Switching apps is [ticket exchange](/guide/ticket-exchange), not a second password login.

```
1. POST /v3/profiles/sessions     Basic + AppId A
2. ticket set            → full session
   twoFactorAuthenticationTicket set, ticket null
                         → 2FA ticket (limited scope as ubi_v1 t=…)
                           or complete 2FA with Ubi_2fa_v1 t=… + ubi-2facode
3. GET  /v3/users/me              ubi_v1 t=ticket, AppId A
4. POST /v3/profiles/sessions     ubi_v1 t=ticket, AppId B
5. Scoped Session for AppId B
```

## Password login {#password-login}

Send HTTP Basic where the user-info is `email:password`, then Base64.

```
Authorization: Basic {base64(email + ':' + password)}
```

Pair it with an app ID. The usual first hop is **Main Auth / uplay mobile**:

`4391c956-8943-48eb-8859-07b0778f47b9`

Full request/response types: [Create session](/endpoints/auth#create-session).

Keep the password off disk. Prefer exchanging an existing ticket, or using `rememberMeTicket` when you already have one, over storing the password.

## Ticket {#ticket}

After a successful login, every follow-up request uses:

```
Authorization: ubi_v1 t={ticket}
Ubi-SessionId: {sessionId}
```

Official clients often send `Ubi_v1` (capital U). Both forms work.

`sessionId` is a separate UUID from the session payload. Some endpoints tolerate a missing session header; most official clients send both.

### Remember-me

The session payload may include `rememberMeTicket`. Treat it as a long-lived refresh credential for the **same** app ID. Re-login with it the same way you would a normal ticket exchange if you are staying on that app; if the server rejects it, fall back to password (and 2FA).

## Two-factor {#two-factor}

::: warning HTTP 200 does not mean you have a full ticket
When login returns **200** with `ticket: null` and a populated `twoFactorAuthenticationTicket`, 2FA is enabled on the account. That value is still a credential, but it is **not** a full ticket. Scope and access are limited until 2FA is completed and a real `ticket` is issued.
:::

### Use the 2FA ticket directly {#2fa-ticket}

Send it with the same scheme as a normal ticket. This works for a **narrower** set of calls (pre-2FA / limited scope). It is not a substitute for ticket exchange or for endpoints that require a completed login.

```
Authorization: ubi_v1 t={twoFactorAuthenticationTicket}
```

Do not treat `body.ticket` and `body.twoFactorAuthenticationTicket` as interchangeable.

### Complete 2FA {#complete-2fa}

Same path as [create session](/endpoints/auth#create-session). This exchanges the 2FA ticket for a full [`Session`](/guide/common-types#session).

```http
POST https://public-ubiservices.ubi.com/v3/profiles/sessions
Authorization: Ubi_2fa_v1 t={twoFactorAuthenticationTicket}
Ubi-AppId: {same app id as the password login}
Ubi-RequestedPlatformType: uplay
Content-Type: application/json
ubi-2facode: {6-digit code}
```

```ts
type CompleteTwoFactorBody = {
  trustedDevice: null
}
```

`ubi-2facode` is a six-digit TOTP / email code. Scheme is `Ubi_2fa_v1` or `ubi_2fa_v1` — not `ubi_v1`. Body is `{ "trustedDevice": null }` or `{ "rememberMe": true }`. After this succeeds, use the returned `ticket` and `sessionId`.

Check current 2FA configuration once you have a full ticket:

- [`GET /v3/profiles/me/2fa`](/endpoints/auth#2fa-status)
- [`GET connect …/webauth/check2fa`](/endpoints/auth#connect-check-2fa)

Setup / teardown: [Account management](/endpoints/account#two-factor-setup).

## Extracting `userId` from a ticket

If you have a ticket but not the user UUID:

- Prefer the `userId` on the [`Session`](/guide/common-types#session) you just received
- Or [`GET /v1/profiles/me`](/endpoints/user#current-profile-v1) which returns `userId` for the current session

`userId` and uplay `profileId` are often the same UUID on PC, but **do not assume that** once Xbox / PSN / Epic / Steam profiles are linked. Always read [linked profiles](/endpoints/user#linked-profiles).

## What not to do

- Do not send a [2FA ticket](/guide/authentication#two-factor) where a full `ticket` is required. Scope and access are limited.
- Do not send one ticket with a random other `Ubi-AppId` and expect it to work. Exchange first.
- Do not treat CERT2 / UAT tickets as valid on PROD ([environments](/guide/environments)).
- Do not hammer `/sessions` with credential lists. That is abuse, not an API client.
