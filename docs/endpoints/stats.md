# Stats & rank (R6 Siege)

Ranked 2.0 and Ranked 3.0 skill plus legacy karma MMR. Shared type: [`SkillProfile`](/guide/common-types#skill-profile).

**spaceId:** [R6 primary](/guide/identifiers#space-ids) `0d2ae42d-4c27-4cb7-af6c-2099062302bb`.

Whether other people can see stats is gated by [`stats` consent](/endpoints/consent).

---

## Current ranked {#current-ranked}

<Endpoint method="GET" path="/v2/spaces/{spaceId}/title/r6s/skill/full_profiles?platform_families=console,pc&profile_ids={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Current season skill for PC and console families. This endpoint serves both **Ranked 2.0 and Ranked 3.0**. The URL remains `/v2/.../skill/full_profiles`; the API version is separate from the ranked system version.

### Query

| Name | Notes |
|---|---|
| `platform_families` | `console,pc` to get both; or a single family |
| `profile_ids` | Target UUID (comma-separated batch possible) |

### Response

Nested `platform_families_full_profiles` → boards → [`SkillProfile`](/guide/common-types#skill-profile).

Useful fields on `profile`: `rank` (0–36), `rank_points`, `max_rank`, `max_rank_points`, `season_id`, `top_rank_position`. On `season_statistics`: kills, deaths, wins, losses, abandons.

`rank` `0` is unranked.

---

## Archived ranked {#archived-ranked}

<Endpoint method="GET" path="/v2/spaces/{spaceId}/title/r6s/skill/archived_profile?platform_families=console,pc&profile_ids={userId}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Historical / previous seasons. **Same schema** as [`full_profiles`](#current-ranked) — drop-in path swap.

Use this for season history; use `full_profiles` for “what is their rank right now.”

---

## Legacy seasonal MMR {#legacy-seasonal}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/sandboxes/OSBOR_PS4_LNCH_A/r6karma/player_skill_records?board_ids=pvp_ranked&season_ids={seasons}&profile_ids={id}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Pre–Ranked 2.0 seasonal MMR. `season_ids` is a comma-separated list of old season numbers. Sandbox id `OSBOR_PS4_LNCH_A` is the historical karma sandbox (name is leftover; it is not PS4-only).

Use [`full_profiles`](#current-ranked) for the current season in Ranked 2.0 and Ranked 3.0.

---

## Legacy current ranked {#legacy-current}

<Endpoint method="GET" path="/v1/spaces/{spaceId}/sandboxes/OSBOR_PS4_LNCH_A/r6karma/players?profile_ids={id}" appId="Main Auth 4391c956-…" appHref="/guide/identifiers#app-ids" />

Pre–Ranked 2.0 “current” ranked payload. Same sandbox. Obsolete for live ranked.

---

## Connect profile stats {#connect-stats}

Generic profile stats used by the account / Connect website. For current-season ranked skill, use [`full_profiles`](#current-ranked).

<Endpoint method="GET" path="/v1/profiles/{profileId}/stats" host="connect" appId="Account website 74e71609-…" appHref="/guide/identifiers#app-ids" />

Query: `spaceId`, `period`, `calendarEntryId`, `statNames` (comma-separated), `limit`, `nextToken`.

---

## Current summary {#current-summary}

Official tracker / Tab-style summary. Same path on **public-ubiservices** and `https://r6s-stats-dev.ubisoft.com`.

<Endpoint method="GET" path="/v1/current/summary/{profileId}?gameMode=pvp&platform=PC&startDate=&endDate=" appId="R6 stats tracker 39baebad-…" appHref="/guide/identifiers#app-ids" />

| Query | Notes |
|---|---|
| `gameMode` | `pvp` |
| `platform` | `PC` / `PS4` / `XONE` |
| `startDate` / `endDate` | `YYYYMMDD` |

Also send `Expiration` (session expiry) on the tracker client.

<Endpoint method="GET" path="/v1/current/summary/{profileId}" host="custom" origin="https://r6s-stats-dev.ubisoft.com" appId="R6 stats tracker 39baebad-…" appHref="/guide/identifiers#app-ids" />

---

## Precise match state {#precise-match}

<Endpoint method="GET" path="/v1/profiles/{profileId}/matches/precise/matchstate?platform=PC" appId="R6 stats tracker 39baebad-…" appHref="/guide/identifiers#app-ids" />

`platform` is `PC` / `PS4` / `XONE` (or `uplay` / `psn` / `xbl` in older notes). Used for “in this match right now” tracker features.
