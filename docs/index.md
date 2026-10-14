---
layout: home
hero:
  name: Ubisoft API
  text: Unofficial endpoint reference
  tagline: API endpoints, authentication, and response types for Ubisoft Connect and ubi-services.
  actions:
    - theme: brand
      text: Get started
      link: /guide/getting-started
    - theme: alt
      text: Authentication
      link: /guide/authentication
    - theme: alt
      text: All endpoints
      link: /endpoints/
features:
  - title: Authentication
    details: Password login, two-factor authentication, and application ticket exchange.
  - title: Typed responses
    details: TypeScript definitions for documented request and response fields.
  - title: Rainbow Six Siege
    details: Inventory, offers, ranked skill, penalties, marketplace GraphQL, and consent settings.
---

::: warning Unofficial
These internal Ubisoft endpoints are not a public, supported API and may change without notice. This site is not affiliated with Ubisoft.
:::

## How to read this site

| You want… | Go here |
|---|---|
| A working request in a REST client | [Getting started](/guide/getting-started) |
| How tickets, 2FA, and app IDs fit together | [Authentication](/guide/authentication) → [Ticket exchange](/guide/ticket-exchange) |
| Which `Ubi-AppId` / `spaceId` to send | [Identifiers](/guide/identifiers) |
| Shared field shapes (`Session`, `Profile`, …) | [Common types](/guide/common-types) |
| A specific HTTP route | [Endpoint index](/endpoints/) |
