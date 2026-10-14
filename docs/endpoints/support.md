# Support

Customer-support cases and account recovery. These sit on ubi-services but expect a **dedicated session** with [Main Auth](/guide/identifiers#app-ids) `4391c956-8943-48eb-8859-07b0778f47b9` — often a **third** ticket after profile + game, via [ticket exchange](/guide/ticket-exchange).

---

## List cases {#list-cases}

<Endpoint method="GET" path="/v1/profiles/me/global/cshelp/cases/api/cases/" appId="Main Auth 4391c956-… (3rd session)" appHref="/guide/identifiers#app-ids" />

Support cases for the authenticated account.

### Headers

[Standard headers](/guide/headers) with that third session.

---

## Case detail {#case-detail}

<Endpoint method="GET" path="/v1/profiles/me/global/cshelp/cases/api/case/{caseNumber}" appId="Main Auth 4391c956-… (3rd session)" appHref="/guide/identifiers#app-ids" />

One case. `{caseNumber}` comes from the list.

---

## Account recovery {#account-recovery}

<Endpoint method="POST" path="/v1/applications/global/cshelp/cases/api/account-recovery-cases" auth="none" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Submit an account-recovery case. Requires reCAPTCHA.
