# Headers

Send this set on authenticated ubi-services calls unless an endpoint page says otherwise. Endpoint pages do **not** repeat this table.

```http
Authorization: ubi_v1 t={ticket}
Ubi-AppId: {appId}
Ubi-SessionId: {sessionId}
Ubi-RequestedPlatformType: uplay
Ubi-LocaleCode: en-US
Content-Type: application/json
User-Agent: Mozilla/5.0
```

| Header | Required | Notes |
|---|---|---|
| `Authorization` | Yes | `ubi_v1 t={ticket}` or `Ubi_v1 t={ticket}` after login; `Basic {base64(email:password)}` on [password login](/guide/authentication#password-login); `Ubi_2fa_v1 t={twoFactorAuthenticationTicket}` (or `ubi_2fa_v1`) on [complete 2FA](/guide/authentication#complete-2fa) |
| `Ubi-AppId` | Yes | Must match the ticket's app. Casing `Ubi-AppId` / `Ubi-appid` both work. See [App IDs](/guide/identifiers#app-ids) |
| `Ubi-SessionId` | Usually | UUID from the [`Session`](/guide/common-types#session) |
| `Ubi-RequestedPlatformType` | Usually | `uplay` for PC. Other clients send `xbl`, `psn`, `steam`, etc. |
| `Ubi-LocaleCode` | No | `en-US` / `en-GB` |
| `Content-Type` | On bodies | `application/json` |
| `User-Agent` | Soft | Browser UA, or `UbiServices_SDK_2022.Release.39_PC64_ansi_static` on some SDK clients |
| `ubi-2facode` / `Ubi-2FACode` | 2FA | Six-digit code on [complete 2FA](/guide/authentication#complete-2fa) and some account 2FA writes |
| `GenomeId` | Mail-link / family | Unauthenticated activation, email change, password reset, and family calls from account.ubisoft.com |
| `UserId` | SSO | `POST` [SSO refresh](/endpoints/sso#refresh) when resolving an SSO id from a ubi `userId` |
| `Ubi-TransactionId` | SMS reset | Password reset completed by SMS |

## Optional extras

Seen on a subset of routes (presence, inventory, GraphQL, geo):

```http
ubi-regionid: WW
ubi-countryid: US
ubi-profileid: {userId}
x-platform-appid: {platformAppId}
Origin: https://connect.cdn.ubisoft.com
apollographql-client-version: 1.56.1
Accept-Encoding: gzip, deflate, br
```

Only set these when the endpoint page mentions them.

## reCAPTCHA challenge {#challenge}

Account.ubisoft.com sensitive writes send:

```http
Ubi-Challenge: cce={base64("sitekey={siteKey}&token={token}")}
```

`1301` in the error body means the challenge was required or rejected. See [Errors](/guide/errors).

Some mail-link and family routes also send `GenomeId`. SSO refresh from the account site sends `UserId`.

## Connect vs ubi-services

`connect.ubisoft.com` is two different things:

| Surface | Auth |
|---|---|
| [Cross-channel SSO](/endpoints/sso) (`/v2/crosschannelauth/…`, `check2fa`) | Website SSO cookies |
| Account-site Connect APIs (countries, avatars, catalog, games played, profile stats) | Same `ubi_v1` ticket set as ubi-services |

Don't send the ticket set to the SSO routes and expect it to replace cookies. Do send it to the account-site Connect REST routes — those are ticket APIs that happen to live on the Connect host.
