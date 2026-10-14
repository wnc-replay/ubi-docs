# Fetch application space IDs

Run from the repository root in PowerShell (Windows PowerShell 5.1 or PowerShell 7):

```powershell
.\scripts\fetch-spaceids.ps1
```

The script prompts for your Ubisoft email, hidden password, and a six-digit 2FA code when required. It obtains one ticket using app ID `d5fa0769-5139-4671-8f83-3479176edafd` (Bug reporter) and calls `GET /v1/applications/{appId}` for every unique app ID in `docs/public/identifiers/appids.txt`. Use `-AppIdsPath` to select another file. The file must contain one UUID per line; blank lines and lines beginning with `#` are ignored. IDs are deduplicated in their original order, and invalid lines stop the script before login. The identifiers document supplies labels where available; it does not limit the app list. The same authentication app ID is used for login, 2FA, and every lookup; target application IDs are URL parameters.

Results go to `output/app-spaces.json`, updated after each lookup. Each entry includes the documented label, app ID, HTTP status, and distinct UUIDs found in `spaceId`, `spaceIds`, or `stagingSpaceId` fields, including nested response objects. `no-space-id` means the response contained none of these UUID fields. An app can have zero or multiple space IDs. Tickets, session IDs, passwords, and raw responses are never written to the report.

Requests are sequential, with no added delay between lookups and a 30-second request timeout. HTTP 401 or 429 stops the run and preserves partial results; no automatic retries are made. Other lookup failures are recorded and the remaining apps are attempted. `complete` means every app was attempted, not that every lookup succeeded. Existing output files are not overwritten.

```powershell
# Preview the current app list without login or network requests:
.\scripts\fetch-spaceids.ps1 -ListApps

# Use another list:
.\scripts\fetch-spaceids.ps1 -AppIdsPath 'C:\path\to\appids.txt'

# Choose a fresh output path:
.\scripts\fetch-spaceids.ps1 -OutputPath .\output\app-spaces-second-run.json
```

The script uses the API contracts recorded in this repository. Live access depends on your account and Ubisoft's current endpoint behavior.
