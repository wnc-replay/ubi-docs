# Account management

Routes used by **account.ubisoft.com**. [Exchange](/guide/ticket-exchange) to an account app ID first:

| Purpose | ID |
|---|---|
| Account management | `afb4b43c-f1f7-41b7-bcef-a635d8c83822` |
| Account website (osClient) | `74e71609-1ddf-47da-9073-71ac3aa8c90c` |
| Connect client (login hop) | `f68a4bb5-608a-4ff2-8123-be8ef797e0a6` |

Sensitive writes add [`Ubi-Challenge`](/guide/headers#challenge) (reCAPTCHA). Some unauthenticated mail-link calls also send `GenomeId`.

Login / 2FA-at-login: [Authentication](/guide/authentication).

---

## 2FA enrollment {#two-factor-setup}

<Endpoint method="GET" path="/v3/profiles/me/2fa" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="POST" path="/v3/profiles/me/start2faActivation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "codeGenerationPreference": "{preference}" }` plus `Ubi-Challenge`.

<Endpoint method="POST" path="/v3/profiles/me/2fa" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "2faActivationKey": "{key}" }` plus `Ubi-Challenge`.

<Endpoint method="PUT" path="/v3/profiles/me/2fa" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Update settings. Headers include `Ubi-2FACode` and `Ubi-Challenge`.

<Endpoint method="DELETE" path="/v3/profiles/me/2fa" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="POST" path="/v3/profiles/me/2facode" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Request a code (email/SMS). `Ubi-Challenge` required.

---

## Trusted devices {#trusted-devices}

<Endpoint method="GET" path="/v3/profiles/me/trusteddevices" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Also seen as `/v3/users/{userId}/trustedDevices`.

<Endpoint method="PUT" path="/v3/profiles/me/trusteddevices/{id}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "friendlyName": "{name}" }`.

<Endpoint method="DELETE" path="/v3/profiles/me/trusteddevices/{id}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

---

## Email {#email}

<Endpoint method="POST" path="/v3/users/startChangeEmail" auth="none" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "email": "{newEmail}", "nextUrl": "_" }`. `GenomeId` + `Ubi-Challenge`. Authorization omitted.

<Endpoint method="POST" path="/v3/users/{userId}/completeChangeEmail" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

```ts
type CompleteChangeEmailBody = {
  emailValidationCode: string
  newEmail: string
  identityToken: string
} | {
  newEmail: string
  resetKey: string
}
```

---

## Activation {#activation}

<Endpoint method="POST" path="/v3/users/startActivation" auth="none" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

`GenomeId` + `Ubi-Challenge`.

<Endpoint method="PUT" path="/v3/users/completeActivation" auth="none" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "email": "{email}", "activationKey": "{key}" }`.

---

## Password reset {#password-reset}

<Endpoint method="POST" path="/v3/users/startResetPassword" auth="none" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "email": "{email}", "nextUrl": "{url}" }`.

<Endpoint method="POST" path="/v3/users/completeResetPassword" auth="none" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Mail-link body: `{ "email", "password", "resetKey" }`. SMS variant adds `countryCallingCode`, `phoneNumber`, `identityToken`, and `Ubi-TransactionId`.

Password rules: [`GET /v1/users/passwords/rules`](/endpoints/misc#password-rules).

---

## Phone {#phone}

<Endpoint method="POST" path="/v3/users/me/phoneValidationCode" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="POST" path="/v3/users/me/startPhoneActivation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="POST" path="/v3/users/me/completePhoneActivation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="PATCH" path="/v3/users/me" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Remove phone: `{ "phone": null }`.

---

## Age verification {#start-age-verification}

<Endpoint method="POST" path="/v3/users/{userId}/startAgeVerification" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "callbackUrl": "{url}", "cancelUrl": "{url}" }`.

<Endpoint method="POST" path="/v3/users/{userId}/cancelAgeVerification" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

---

## Family / guardian {#family}

<Endpoint method="GET" path="/v3/users/me/family" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Header: `GenomeId`.

<Endpoint method="POST" path="/v3/users/{userId}/startGuardianLinkWithTeen" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

`{userId}` is the teen. Body: `{ "guardianEmail": "{email}" }`. `GenomeId` + `Ubi-Challenge`.

<Endpoint method="POST" path="/v3/users/{userId}/completeGuardianLinkWithTeen" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

`{userId}` is the guardian / parent. Body: `{ "teenUserId": "{userId}", "guardianLinkToken": "{token}" }`. `GenomeId`.

<Endpoint method="POST" path="/v3/users/validateCompleteMinorCreation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="POST" path="/v3/users/completeMinorCreation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

---

## Cancel deletion {#cancel-deletion}

<Endpoint method="POST" path="/v3/users/completeCancelDeletion" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Body: `{ "cancelKey", "email", "executorId?" }`.

<Endpoint method="POST" path="/v3/users/{userId}/completeCancelDeletion" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Per-user variant. Empty body.

---

## Validation codes {#validation-codes}

<Endpoint method="POST" path="/v3/users/{userId}/validationCodes/{mode}" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Issue a code (email/phone). `{mode}` is the channel. `Ubi-Challenge` required.

```ts
type ValidationCodeBody = {
  email: string
  context: string
}
```

<Endpoint method="POST" path="/v3/users/{userId}/validationCodes/{mode}/validation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Check the code. Same challenge header.

```ts
type ValidationCodeCheckBody = {
  validationCode: string
  context: string
}
```

---

## Opt-ins {#optins}

<Endpoint method="GET" path="/v1/users/me/optins" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="PUT" path="/v1/users/me/optins" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

PUT body is the opt-in object the GET returned (shape varies by country/age).

<Endpoint method="GET" path="/v1/users/configs/optins/{countryCode}?ageGroup=" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/spaces/{spaceId}/configs/usercontrols/globaloptins?countryCode=&ageGroup=" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

User-controls catalogue. Send `Ubi-LocaleCode`. Opt-ins space: `674bda67-9a08-48dd-8596-d467684d8c6c`.

---

## Communication preferences {#communication}

<Endpoint method="GET" path="/v2/users/me/communicationPreferences" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="PUT" path="/v2/users/me/communicationPreferences" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

PUT body from the account site is `{ "2faCode": "{communicationPreference}" }` — the field name is `2faCode` even though this is the communication-preference value, not a 2FA login code.

---

## OAuth clients {#oauth}

<Endpoint method="GET" path="/v1/profiles/{profileId}/applications/oauth/clients/consents?offset=0&limit=50" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Optional query: `applicationIds` (array). Send `Ubi-LocaleCode`.

<Endpoint method="DELETE" path="/v1/profiles/{profileId}/applications/{applicationId}/oauth/clients/consents" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

---

## Personal data export {#data-export}

<Endpoint method="POST" path="/v1/users/{userId}/personalData/extractions" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/users/{userId}/personalData/extractions" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="GET" path="/v1/users/{userId}/personalData/extractions/{extractionId}/download" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Download is a blob.

---

## Amazon Prime Gaming {#prime}

<Endpoint method="POST" path="/api/external/v1/amazonprimegaming/prime" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="DELETE" path="/v2/externalparties/public/amazonprimegaming/prime" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

POST links (`/api/external/…` on ubi-services). DELETE unlinks (`/v2/externalparties/…`).

---

## Spending limits {#spending-limits}

<Endpoint method="GET" path="/v3/users/{userId}/policies/spendingLimits" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

<Endpoint method="PUT" path="/v3/users/{userId}/policies/spendingLimits" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

PUT body: `{ "limit": {value} }`.

---

## Spent {#spent}

<Endpoint method="GET" path="/api/v1/users/{userId}/spent/{currency}" host="scs" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Money spent in `{currency}` for that user. Host is **SCS ecom** (`scs.ecom.ubi.com`), not ubi-services. account.ubisoft.com wires this as `scsClient.scsApi.getSpentMoney`.

---

## Policies {#policies}

<Endpoint method="GET" path="/v3/policies/{countryCode}?languageCode=&contentFormat=html" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Legal / policy HTML for a country. `languageCode` is the locale; `contentFormat` is `html` in the official client.

---

## Subscriptions {#subscriptions}

<Endpoint method="GET" path="/v2/subscriptions?filter=ubisoftAccountId eq '{userId}'" host="ecom" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Host is **USS**. account.ubisoft.com uses `https://uss.ecom.ubi.com`; some other official clients use `https://uss.ubi.com` for the same path (UAT/CERT2/DEV: `https://uss.uat.ecom.ubi.com`). The account client remaps HTTP `403` to `401` locally; the server still returns 403.

---

## ESS subscription {#ess-subscription}

<Endpoint method="GET" path="/account/{userId}/subscription?type=" host="ess" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Per-type subscription on **ESS** (`https://ess.ubi.com` in PROD; `https://ess.uat.ecom.ubi.com` on CERT2/UAT/DEV). Query `type` is required.

```ts
type EssSubscription = {
  id: string
  userId: string // ubisoftAccountId
  startedAt?: string
  type: string
  level?: string
  creatorId?: string // creatorAppId
  status: string
  isActive: boolean // status is "active" or "suspended"
  isCancellationInProgress?: boolean
}
```

Host table: [Environments → Ecommerce](/guide/environments#ecommerce).
