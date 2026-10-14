# Identifiers

UUIDs below are **production** IDs observed in official clients. Endpoint pages link here instead of pasting the same table.

For the full list, see the [Application and space catalogue](./application-space-catalogue): 1,071 app IDs, 1,002 unique space IDs, and downloadable text/JSON files.

## Space IDs {#space-ids}

A *space* is a title/sandbox container. Rainbow Six Siege inventory, offers, skill, and penalties all take `spaceId`.

| Purpose | ID |
|---|---|
| R6 Siege (primary) | `0d2ae42d-4c27-4cb7-af6c-2099062302bb` |
| R6 Siege (alt / legacy) | `5172a557-50b5-4665-b7db-e3f2e8c5041d` |
| R6 stats tracker (observed) | `632df4a5-4fd7-4ee5-a0c8-1f221f7e585f` |
| Free-games / news feed | `6d0af36b-8226-44b6-a03b-4660073a6349` |
| Connect news carousel | `66fcdb38-e7c2-45dd-a1c4-acbd7086d00f` |

Use **primary** unless a legacy karma/sandbox path says otherwise.

## App IDs {#app-ids}

`Ubi-AppId` selects the application the [ticket](/guide/authentication#ticket) is minted for. Wrong app ID → `401` / unauthorized even with a fresh ticket. [Exchange](/guide/ticket-exchange) instead of guessing.

| Purpose | ID |
|---|---|
| Main Auth / uplay mobile | `4391c956-8943-48eb-8859-07b0778f47b9` |
| Secondary (app-data / sessions) / R6 Siege PC consent | `e3d5ea9e-50bd-43b7-88bf-39794f4e3d40` |
| Account management | `afb4b43c-f1f7-41b7-bcef-a635d8c83822` |
| Account website (osClient) | `74e71609-1ddf-47da-9073-71ac3aa8c90c` |
| Ubisoft Connect website | `314d4fef-e568-454a-ae06-43e3bece12a6` |
| Ubisoft Connect client (consent login hop) | `f68a4bb5-608a-4ff2-8123-be8ef797e0a6` |
| Marketplace auth | `aa88e512-9395-457d-bcb9-8d59c23f88c9` |
| Marketplace ops | `804a4e08-8797-44f0-8fce-eabe8f7f0dda` |
| Marketplace (alt) | `685a3038-2b04-47ee-9c5a-6403381a46aa` |
| Inventory worker | `3587dcbb-7f81-457c-9781-0e3f29f6f56a` |
| R6 PC client (stats / inventory / 2FA) | `08393e03-3956-4e0b-95ef-8b3af6083eb8` |
| Inventory (alt) | `49ee246f-70b9-4f2c-9036-0893b6f77576` |
| IP location / data requests | `4008612d-3baf-49e4-957a-33066726a7bc` |
| Party / GraphQL parties / friend requests | `0a0379c0-c673-4183-bf32-48e72f9dc91f` |
| Connect PC / metaprogression | `83564d31-7cd7-4bc0-a763-6524e78d1a7f` |
| R6 stats tracker (Tab / summary) | `39baebad-39e5-4552-8c25-2c9b919064e2` |
| Login (alternate) | `503a4b49-12c9-47b9-b26d-6a1a7e38c08c` |
| r6skins locker | `d1c666c8-51bb-42c8-8b76-1e224f451176` |
| Bug reporter (current) | `d5fa0769-5139-4671-8f83-3479176edafd` |
| Bug reporter (earlier web) | `f6214bf2-584f-47c2-ab4e-c6b1e8375925` |
| Xbox Live linking | `86547fce-770c-43d9-af45-ff7cac727081` |
| Amazon / Twitch linking | `4074ced1-66fb-4c62-a329-bce5c3b4d399` |
| Amazon / Twitch (alt) / some SDK creates | `3eec05a6-d0c8-4acc-99e6-081abb39b181` |
| Amazon / Twitch (alt) | `1c21cecc-c3a9-4052-8a70-b08279940d2c` |

Support cases also expect a session minted with **Main Auth** `4391c956-…` (often a dedicated third session).

## Other IDs {#other-ids}

| Purpose | ID |
|---|---|
| R6 bug-reporter installment | `7f166d62-3f97-4ab7-a460-6c33f8a6875e` |
| Account opt-ins space | `674bda67-9a08-48dd-8596-d467684d8c6c` |
| Friends invites space | `e4454923-3ac4-459b-8a84-d50601e5b9ee` |
| Connect PC (`x-platform-appid`) | `83564d31-7cd7-4bc0-a763-6524e78d1a7f` (same as the app ID above) |

## Item / currency IDs (R6 Siege) {#item-ids}

From [inventory](/endpoints/inventory). Cosmetics have no `quantity`; these currency rows do.

| Purpose | ID |
|---|---|
| Renown | `61467f3b-c1a5-45de-b738-ef59ab9339ff` |
| R6 Credits | `9ef71262-515b-46e8-b9a8-b6b6ad456c67` |
| Level | `7ab7292b-d390-46d0-9e52-c606f5ee3f71` |

Clearance level via stats is still the canonical number: [`PClearanceLevel`](/endpoints/inventory#clearance-level).

## Privilege IDs {#privilege-ids}

| Purpose | ID |
|---|---|
| Marketplace ban check | `2798fec3-9010-4a24-b902-f21fa1b25e1f` |

Used by [`GET …/playerprivileges`](/endpoints/bans#player-privileges).

## Consent keys {#consent-keys}

Full table with the UUIDs behind each key: [Consent & privacy](/endpoints/consent).
