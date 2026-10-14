# Cross-channel SSO

All of these are on **`https://connect.ubisoft.com`**, prefix `/v2/crosschannelauth`. They keep the **website** logged in across tabs and products. They are not a replacement for [`POST /v3/profiles/sessions`](/endpoints/auth#create-session) when you are talking to ubi-services.

Auth on **these SSO paths** is the Connect cookie jar, not `ubi_v1`. Other Connect-host REST (countries, avatars, catalog) uses a ticket — [Headers → Connect](/guide/headers#connect-vs-ubi-services).

## Refresh {#refresh}

<Endpoint method="POST" path="/v2/crosschannelauth/public/sso/refresh" host="connect" auth="sso" />

Refresh the SSO session.

account.ubisoft.com also posts this path from its Connect client with a ubi-services [ticket](/guide/authentication#ticket) plus header `UserId: {userId}` (`getSsoId`). The Connect website itself uses SSO cookies on the same URL.

<Endpoint method="GET" path="/v2/crosschannelauth/public/sso/refresh" host="connect" auth="sso" />

Read SSO refresh data (same path, GET).

## Entry {#entry}

<Endpoint method="POST" path="/v2/crosschannelauth/public/sso/entry" host="connect" auth="sso" />

Set SSO entry (which product/channel started the session).

<Endpoint method="GET" path="/v2/crosschannelauth/public/sso/entry" host="connect" auth="sso" />

Read the current SSO entry.

## Token {#token}

<Endpoint method="GET" path="/v2/crosschannelauth/public/sso/token" host="connect" auth="sso" />

Read the auth token held by the SSO session. This is what the Connect website later exchanges toward ubi-services.

## Auth {#auth}

<Endpoint method="POST" path="/v2/crosschannelauth/public/sso/auth" host="connect" auth="sso" />

Refresh authentication for the SSO session.

## Static helpers

| Path | Role |
|---|---|
| `https://connect.ubisoft.com/sdk.html` | Communication iframe |
| `https://connect.ubisoft.com/refresh.html` | Token refresh redirect |
| `https://ubistatic2-a.ubisoft.com/uplay-connect/v3/prod/default/sdk/connectSdkPublic.js` | Public Connect web SDK |

The first two are HTML pages, not JSON APIs. Official web clients load them in hidden frames. The SDK script is the Connect client used by account.ubisoft.com.
