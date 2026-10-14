# Misc

## IP geolocation {#ip-location}

<Endpoint method="GET" path="/v2/iplocation/{ip}" appId="IP location 4008612d-…" appHref="/guide/identifiers#app-ids" />

Look up a public IP. `{ip}` is dotted-quad or a v6 literal.

<Endpoint method="GET" path="/v2/profiles/me/iplocation" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Geo for the current session (no IP in the path).

---

## Password rules {#password-rules}

<Endpoint method="GET" path="/v1/users/passwords/rules" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Used by account.ubisoft.com before create / reset. Send `Ubi-LocaleCode`.

---

## Countries {#countries}

<Endpoint method="GET" path="/v2/webauth/public/localizations/countries?locale=en-us" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Country list for registration forms. Host is **Connect**; account.ubisoft.com sends the usual [ticket](/guide/authentication#ticket) session headers, not the website SSO cookie jar.
