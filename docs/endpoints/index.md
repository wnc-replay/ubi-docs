# Endpoint index

Every route in this reference. Shared rules live in the [guide](/guide/getting-started) — these pages only add what is unique.

Host is **PROD** `public-ubiservices` unless noted. Auth is a [ticket](/guide/authentication#ticket) unless noted.

## Auth & session

| Method | Path | Page |
|---|---|---|
| `POST` | `/v3/profiles/sessions` | [Create session](/endpoints/auth#create-session) (password, 2FA complete, or ticket exchange) |
| `GET` | `/v3/profiles/me/2fa` | [2FA status](/endpoints/auth#2fa-status) |
| `GET` | `connect` `/v2/webauth/public/webauth/check2fa` | [Connect 2FA check](/endpoints/auth#connect-check-2fa) |

## Cross-channel SSO (`connect.ubisoft.com`)

| Method | Path | Page |
|---|---|---|
| `POST`/`GET` | `/v2/crosschannelauth/public/sso/refresh` | [SSO refresh](/endpoints/sso#refresh) |
| `POST`/`GET` | `/v2/crosschannelauth/public/sso/entry` | [SSO entry](/endpoints/sso#entry) |
| `GET` | `/v2/crosschannelauth/public/sso/token` | [SSO token](/endpoints/sso#token) |
| `POST` | `/v2/crosschannelauth/public/sso/auth` | [SSO auth](/endpoints/sso#auth) |

## User & profile

| Method | Path | Page |
|---|---|---|
| `GET` | `/v3/users/me` | [Current user](/endpoints/user#current-user) |
| `GET` | `/v3/users/{userId}` | [User by id](/endpoints/user#current-user) |
| `PUT` | `/v3/users/{userId}` | [Save user](/endpoints/user#current-user) |
| `POST` | `/v3/users/{userId}/validateUpdate` | [Validate user save](/endpoints/user#current-user) |
| `DELETE` | `/v3/users/me` | [Delete account](/endpoints/user#delete-account) |
| `DELETE` | `/v3/users/{userId}` | [Delete by id](/endpoints/user#delete-account) |
| `POST` | `/v3/users` | [Create account](/endpoints/user#create-account) |
| `GET` | `/v3/users/{userId}/Profiles` | [Linked profiles](/endpoints/user#linked-profiles) |
| `DELETE` | `/v3/users/{userId}/profiles/{profileId}` | [Unlink platform](/endpoints/user#unlink-platform) |
| `GET` | `/v3/users/{userId}/InitialProfiles` | [Initial / ghost profiles](/endpoints/user#initial-profiles) |
| `GET` | `/v3/profiles?nameOnPlatform=&platformType=` | [Lookup by name](/endpoints/user#lookup-by-name) |
| `GET` | `/v3/profiles?userids=` | [Profiles by userId](/endpoints/user#profiles-by-userid) |
| `GET` | `/v2/profiles?userId=` | [V2 profiles](/endpoints/user#v2-profiles) |
| `PUT` | `/v3/profiles/{profileId}` | [Rename](/endpoints/user#rename) |
| `POST` | `/v3/profiles/{profileId}/validateUpdate` | [Validate rename](/endpoints/user#validate-rename) |
| `PUT` | `/v1/profiles/{profileId}/persona` | [Persona / nickname](/endpoints/user#persona) |
| `GET` | `/v1/profiles/me` | [Current profile v1](/endpoints/user#current-profile-v1) |
| `GET` | `/v1` / `/v3` `/profiles/applications` | [Application history](/endpoints/user#application-history) |
| `GET` | `/v1/profiles/me/gamesplayed` | [Games played](/endpoints/user#games-played) |
| `GET` | `/v1/profiles/{profileId}/global/ubiconnect/economy/api/metaprogression` | [Metaprogression](/endpoints/user#metaprogression) |
| `GET` | `connect` `/v1/profiles/{profileId}/gamesplayed` | [Games played](/endpoints/user#games-played) |
| `GET` | `/v2/profiles/me/friends` | [Friends](/endpoints/user#friends) |
| `GET` | `/v3/profiles/{profileId}/friends` | [Friends](/endpoints/user#friends) |
| `DELETE` | `/v3/profiles/{profileId}/friends/{friendProfileId}` | [Friends](/endpoints/user#friends) |
| `GET` | `/v1/profiles/{userId}/parties` | [Parties](/endpoints/user#parties) |
| `GET` | `/v3/profiles/me/actionLog` | [Action log](/endpoints/user#action-log) |

## Presence, apps, inventory, stats

| Method | Path | Page |
|---|---|---|
| `GET` | `/v1/users/onlineStatuses` | [Online status](/endpoints/presence) |
| `GET` | `/v1/applications` / `{appId}` / `/v1/spaces/{spaceId}` | [Applications & spaces](/endpoints/applications) |
| `GET` | `connect` `/v1/spaces/global/ubiconnect/games/api/catalog` | [Connect catalog](/endpoints/applications#connect-catalog) |
| `GET` | `connect` `/v1/mdm/products` | [MDM products](/endpoints/applications#mdm-products) |
| `GET` | `/v1/spaces/news` | [Space news](/endpoints/applications#space-news) |
| `GET` | `/v1/profiles/{userId}/inventory` | [Inventory](/endpoints/inventory#inventory) |
| `POST` | `/v1/profiles/{profileId}/inventory` | [Redeem offer](/endpoints/inventory#redeem-offer) |
| `GET` | `/v1/spaces/{spaceId}/offers` `/offers/all` `/items/all` | [Catalogues](/endpoints/inventory#offer-catalogue) |
| `GET` | `/v1/profiles/stats` (`PClearanceLevel`) | [Clearance level](/endpoints/inventory#clearance-level) |
| `GET` | `/v2/spaces/{spaceId}/title/r6s/skill/full_profiles` | [Current ranked (2.0 / 3.0)](/endpoints/stats#current-ranked) |
| `GET` | `/v2/.../skill/archived_profile` | [Archived ranked](/endpoints/stats#archived-ranked) |
| `GET` | `connect` `/v1/profiles/{profileId}/stats` | [Connect profile stats](/endpoints/stats#connect-stats) |
| `GET` | `/v1/current/summary/{profileId}` | [Current summary](/endpoints/stats#current-summary) |
| `GET` | `/v1/profiles/{profileId}/matches/precise/matchstate` | [Precise match](/endpoints/stats#precise-match) |

## Bans, marketplace, consent, other

| Method | Path | Page |
|---|---|---|
| `GET` | `/v1/spaces/{spaceId}/title/r6s/profiles/me/active_penalties` | [Active penalties](/endpoints/bans#active-penalties) |
| `GET` | `/v2/profiles/{userId}/playerprivileges` | [Privileges](/endpoints/bans#player-privileges) |
| `POST` | `/v1/profiles/me/uplay/graphql` | [Marketplace / parties / friends / profiles](/endpoints/marketplace) |
| `GET`/`POST` | Support cases / recovery | [Support](/endpoints/support) |
| various | Bug reporter issues / contributions | [Bug reporter](/endpoints/bug-reporter) |
| various | Age verification, email, 2FA, Prime, opt-ins, spending, policies | [Account](/endpoints/account) |
| `POST` | `/v3/users/{userId}/validationCodes/{mode}` | [Validation codes](/endpoints/account#validation-codes) |
| `GET`/`PUT` | `/v3/users/{userId}/policies/spendingLimits` | [Spending limits](/endpoints/account#spending-limits) |
| `GET` | `scs` `/api/v1/users/{userId}/spent/{currency}` | [Spent](/endpoints/account#spent) |
| `GET` | `/v3/policies/{countryCode}` | [Policies](/endpoints/account#policies) |
| `GET` | `ecom` `/v2/subscriptions` | [Subscriptions](/endpoints/account#subscriptions) |
| `GET` | `ess` `/account/{userId}/subscription` | [ESS subscription](/endpoints/account#ess-subscription) |
| `GET`/`PATCH` | `/v2/profiles/{id}/consents` | [Consent](/endpoints/consent) |
| `GET` | `/v2/spaces/configs/consents` | [Consent catalogue](/endpoints/consent#set-v2) |
| `GET` | `/v2/iplocation/{ip}` | [IP location](/endpoints/misc#ip-location) |
| `GET` | `/v2/profiles/me/iplocation` | [IP location](/endpoints/misc#ip-location) |
| `GET` | `/v1/users/passwords/rules` | [Password rules](/endpoints/misc#password-rules) |
| `GET` | `connect` `/v2/webauth/public/localizations/countries` | [Countries](/endpoints/misc#countries) |
| CDN / Connect | Avatars, galleries, covers, Algolia, CMS | [CDN](/endpoints/cdn) |
