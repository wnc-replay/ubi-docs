[CmdletBinding()]
param(
    [string]$Email,
    [string]$AppIdsPath = (Join-Path $PSScriptRoot '../docs/public/identifiers/appids.txt'),
    [string]$IdentifiersPath = (Join-Path $PSScriptRoot '../docs/guide/identifiers.md'),
    [string]$OutputPath = (Join-Path $PSScriptRoot '../output/app-spaces.json'),
    [switch]$ListApps
)

$ErrorActionPreference = 'Stop'
$baseUrl = 'https://public-ubiservices.ubi.com'
$authAppId = 'd5fa0769-5139-4671-8f83-3479176edafd'

function Get-DocumentedApps {
    $markdown = Get-Content -LiteralPath $IdentifiersPath -Raw
    $section = [regex]::Match($markdown, '(?ms)^## App IDs[^\r\n]*\r?\n(.*?)(?=^## |\z)')
    if (-not $section.Success) { throw 'App IDs section not found in identifiers document.' }
    $seen = @{}
    foreach ($match in [regex]::Matches($section.Groups[1].Value, '(?m)^\|\s*([^|]+?)\s*\|\s*`([0-9a-fA-F-]{36})`\s*\|')) {
        $id = ([guid]$match.Groups[2].Value).ToString()
        if (-not $seen.ContainsKey($id)) {
            $seen[$id] = $true
            [pscustomobject]@{ appId = $id; label = $match.Groups[1].Value.Trim() }
        }
    }
}

function Get-Apps {
    $labels = @{}
    if (Test-Path -LiteralPath $IdentifiersPath) {
        foreach ($app in Get-DocumentedApps) { $labels[$app.appId] = $app.label }
    }
    $seen = @{}
    $lineNumber = 0
    foreach ($line in Get-Content -LiteralPath $AppIdsPath) {
        $lineNumber++
        $text = $line.Trim()
        if (-not $text -or $text.StartsWith('#')) { continue }
        $parsed = [guid]::Empty
        if (-not [guid]::TryParseExact($text, 'D', [ref]$parsed)) {
            throw "Invalid app ID at line $lineNumber in $AppIdsPath. Expected one UUID per line; no requests sent."
        }
        $id = $parsed.ToString()
        if (-not $seen.ContainsKey($id)) {
            $seen[$id] = $true
            $label = if ($labels.ContainsKey($id)) { $labels[$id] } else { $id }
            [pscustomobject]@{ appId = $id; label = $label }
        }
    }
}

function Invoke-UbiRequest {
    param([string]$Method, [string]$Path, [hashtable]$Headers, [string]$Body)
    $arguments = @{
        Uri = "$baseUrl$Path"; Method = $Method; Headers = $Headers
        ContentType = 'application/json'; UserAgent = 'Mozilla/5.0'
        TimeoutSec = 30; MaximumRedirection = 0; ErrorAction = 'Stop'
    }
    if ($Method -eq 'POST') { $arguments.Body = $Body }
    try {
        $data = Invoke-RestMethod @arguments
        return [pscustomobject]@{ ok = $true; status = 200; data = $data; retryAfter = $null }
    } catch {
        # Do not print raw exception/response bodies: login responses can contain credentials.
        $requestError = $_
        $status = $null
        $retryAfter = $null
        if ($_.Exception.Response) {
            $status = [int]$_.Exception.Response.StatusCode
            try { $retryAfter = [string]$_.Exception.Response.Headers['Retry-After'] } catch { }
        }
        $errorCode = 'unavailable'
        $description = 'No recognized error description returned'
        try {
            $errorText = $requestError.ErrorDetails.Message
            if (-not $errorText -and $requestError.Exception.Response -is [System.Net.HttpWebResponse]) {
                $reader = [IO.StreamReader]::new($requestError.Exception.Response.GetResponseStream())
                try { $errorText = $reader.ReadToEnd() } finally { $reader.Dispose() }
            }
            $errorBody = $errorText | ConvertFrom-Json -ErrorAction Stop
            if ([string]$errorBody.errorCode -match '^\d{1,10}$') { $errorCode = [string]$errorBody.errorCode }
            # Only emit fixed descriptions matched from the message, never arbitrary response text.
            foreach ($phrase in @('invalid credentials', 'invalid email or password', 'invalid password', 'unauthorized application', 'invalid application', 'account locked', 'too many requests', 'too many calls')) {
                if ([string]$errorBody.message -match [regex]::Escape($phrase)) {
                    $description = $phrase
                    break
                }
            }
        } catch { }
        return [pscustomobject]@{
            ok = $false; status = $status; data = $null; retryAfter = $retryAfter
            errorCode = $errorCode; description = $description
        }
    }
}

function Find-SpaceIds {
    param($Value)
    if ($null -eq $Value -or $Value -is [string] -or $Value -is [ValueType]) { return }
    if ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [System.Collections.IDictionary]) {
        foreach ($entry in $Value) { Find-SpaceIds $entry }
        return
    }
    foreach ($property in $Value.PSObject.Properties) {
        if ($property.Name -match '^(spaceId|spaceIds|stagingSpaceId)$') {
            foreach ($candidate in @($property.Value)) {
                $parsed = [guid]::Empty
                if ([guid]::TryParse([string]$candidate, [ref]$parsed)) { $parsed.ToString() }
            }
        }
        Find-SpaceIds $property.Value
    }
}

function Save-Results {
    $report = [ordered]@{
        fetchedAt = [DateTime]::UtcNow.ToString('o')
        source = $AppIdsPath
        authAppId = $authAppId
        totalApps = $apps.Count
        attemptedApps = $results.Count
        complete = ($results.Count -eq $apps.Count)
        results = @($results.ToArray())
    }
    $report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
}

$apps = @(Get-Apps)
if ($apps.Count -eq 0) { throw 'No app IDs found; no requests sent.' }
if ($ListApps) { $apps; return }

$OutputPath = [IO.Path]::GetFullPath($OutputPath)
$outputDirectory = Split-Path -Parent $OutputPath
$null = New-Item -ItemType Directory -Path $outputDirectory -Force
if (Test-Path -LiteralPath $OutputPath) { throw "Output already exists: $OutputPath. Choose a new -OutputPath." }
if (-not $Email) { $Email = Read-Host 'Ubisoft email' }
if ([string]::IsNullOrWhiteSpace($Email)) { throw 'Email is required.' }
$password = Read-Host 'Ubisoft password' -AsSecureString
$headers = @{
    'Ubi-AppId' = $authAppId
    'Ubi-RequestedPlatformType' = 'uplay'
    'Ubi-LocaleCode' = 'en-US'
}
$session = $null
$reply = $null
try {
    $credential = [PSCredential]::new($Email, $password)
    $basicBytes = [Text.Encoding]::UTF8.GetBytes($Email + ':' + $credential.GetNetworkCredential().Password)
    try {
        $headers.Authorization = 'Basic ' + [Convert]::ToBase64String($basicBytes)
        $reply = Invoke-UbiRequest -Method POST -Path '/v3/profiles/sessions' -Headers $headers -Body '{}'
    } finally {
        [Array]::Clear($basicBytes, 0, $basicBytes.Length)
        $headers.Remove('Authorization')
        $credential = $null
        $password.Dispose()
    }
    if (-not $reply.ok) { throw "Login failed (HTTP $($reply.status)); Ubisoft errorCode: $($reply.errorCode); $($reply.description). Auth app: $authAppId. Retry-After: $($reply.retryAfter). No retry was sent." }
    $session = $reply.data
    if (-not $session.ticket -and $session.twoFactorAuthenticationTicket) {
        $code = Read-Host 'Six-digit 2FA code'
        if ($code -notmatch '^\d{6}$') { throw 'Expected a six-digit 2FA code.' }
        $headers.Authorization = 'Ubi_2fa_v1 t=' + $session.twoFactorAuthenticationTicket
        $headers['ubi-2facode'] = $code
        try {
            $reply = Invoke-UbiRequest -Method POST -Path '/v3/profiles/sessions' -Headers $headers -Body '{"trustedDevice":null}'
        } finally {
            $headers.Remove('ubi-2facode')
            $headers.Remove('Authorization')
            $code = $null
        }
        if (-not $reply.ok) { throw "2FA failed (HTTP $($reply.status)); Ubisoft errorCode: $($reply.errorCode); $($reply.description). Retry-After: $($reply.retryAfter). No retry was sent." }
        $session = $reply.data
    }
    if (-not $session.ticket -or -not $session.sessionId) { throw 'Login did not return a full ticket and sessionId.' }
    $headers.Authorization = 'Ubi_v1 t=' + $session.ticket
    $headers['Ubi-SessionId'] = $session.sessionId
    $results = [System.Collections.Generic.List[object]]::new()
    Save-Results
    Write-Host "Authenticated. Looking up $($apps.Count) applications from $AppIdsPath."
    foreach ($app in $apps) {
        $reply = Invoke-UbiRequest -Method GET -Path "/v1/applications/$($app.appId)" -Headers $headers
        $spaceIds = @()
        if ($reply.ok) { $spaceIds = @(Find-SpaceIds $reply.data | Sort-Object -Unique) }
        $state = if (-not $reply.ok) { 'error' } elseif ($spaceIds.Count) { 'ok' } else { 'no-space-id' }
        $results.Add([pscustomobject]@{
            appId = $app.appId; label = $app.label; status = $state
            httpStatus = $reply.status; spaceIds = $spaceIds; retryAfter = $reply.retryAfter
        })
        Save-Results
        Write-Host "[$($results.Count)/$($apps.Count)] $($app.label): $state $($spaceIds -join ', ')"
        if ($reply.status -eq 429 -or $reply.status -eq 401) {
            throw "Stopped on HTTP $($reply.status). Retry-After: $($reply.retryAfter). Partial results: $OutputPath"
        }
    }
    Write-Host "Saved results: $OutputPath"
    if (@($results | Where-Object status -eq 'error').Count) {
        throw 'Some application lookups failed; see the per-app HTTP statuses in the saved report.'
    }
} finally {
    $headers.Clear()
    $session = $null
    $reply = $null
}
