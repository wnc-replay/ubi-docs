# Environments

Ubisoft splits **ubi-services** (profiles, inventory, stats) from **Connect** (web SSO) and **ecom** (subscriptions, spend). Use matching environments — a PROD ticket will not work on CERT2.

| Environment | `public-ubiservices` | `connect` |
|---|---|---|
| **PROD** | `https://public-ubiservices.ubi.com` | `https://connect.ubisoft.com` |
| **CERT2** | `https://cert2-public-ubiservices.ubi.com` | `https://cert2-connect.ubisoft.com` |
| **UAT / TEST** | `https://uat-public-ubiservices.ubi.com` | `https://uat-connect.ubisoft.com` |
| **DEV** | — | `https://dev-connect.ubisoft.com` / `https://localhost.ubisoft.com` |

Unless an endpoint page says otherwise, URLs in this site are **PROD**.

## Ecommerce {#ecommerce}

Same [ticket headers](/guide/headers) as ubi-services, different hosts. account.ubisoft.com uses the `*.ecom.ubi.com` names; other official clients use `uss.ubi.com` / `ess.ubi.com` for the same USS/ESS routes.

| Role | PROD (account site) | PROD (other clients) | CERT2 / UAT / DEV |
|---|---|---|---|
| **USS** (subscriptions) | `https://uss.ecom.ubi.com` | `https://uss.ubi.com` | `https://uss.uat.ecom.ubi.com` |
| **SCS** (spent) | `https://scs.ecom.ubi.com` | — | — |
| **ESS** (per-type subscription) | — | `https://ess.ubi.com` | `https://ess.uat.ecom.ubi.com` |

| Method | Host | Path | Page |
|---|---|---|---|
| `GET` | USS | `/v2/subscriptions?filter=ubisoftAccountId eq '{userId}'` | [Subscriptions](/endpoints/account#subscriptions) |
| `GET` | SCS | `/api/v1/users/{userId}/spent/{currency}` | [Spent](/endpoints/account#spent) |
| `GET` | ESS | `/account/{userId}/subscription?type=` | [ESS subscription](/endpoints/account#ess-subscription) |

CERT2, UAT, and DEV share the `*.uat.ecom.ubi.com` USS/ESS hosts. Non-production SCS hosts are not documented.

## Other origins {#other-origins}

These are not ubi-services either, but they show up next to the same session:

| Role | Origin |
|---|---|
| Player avatars | `https://ubisoft-avatars.akamaized.net` |
| CMS cache | `https://cms-cache.ubisoft.com` |
| Bug reporter | `https://prod-api-bugreporter.ubisoft.com` |
| Connect static helpers | `https://connect.ubisoft.com/sdk.html`, `/refresh.html` |
| Connect SDK (public JS) | `https://ubistatic2-a.ubisoft.com/uplay-connect/v3/prod/default/sdk/connectSdkPublic.js` |
| Algolia (site search) | See [CDN & CMS](/endpoints/cdn) |
| R6 stats (dev / tracker) | `https://r6s-stats-dev.ubisoft.com` — same `/v1/current/summary/{profileId}` path as public-ubiservices |

Avatar URL pattern:

```
https://ubisoft-avatars.akamaized.net/{profileId}/default_146_146.png
```

`profileId` here is the Ubisoft / uplay profile UUID from [`GET /v3/users/{userId}/Profiles`](/endpoints/user#linked-profiles).
