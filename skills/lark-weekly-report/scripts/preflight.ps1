[CmdletBinding()]
param(
    [string]$CliPath = 'lark-cli',
    [string[]]$JsonPath = @()
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = [Text.UTF8Encoding]::new($false)
$strictUtf8 = [Text.UTF8Encoding]::new($false, $true)
$OutputEncoding = [Console]::OutputEncoding = $utf8NoBom
$env:LARKSUITE_CLI_NO_UPDATE_NOTIFIER = '1'
$env:LARKSUITE_CLI_NO_SKILLS_NOTIFIER = '1'

if (Test-Path -LiteralPath $CliPath) {
    $resolvedCli = (Resolve-Path -LiteralPath $CliPath).Path
} else {
    $command = Get-Command $CliPath -ErrorAction Stop
    $resolvedCli = $command.Source
}

$authRaw = (& $resolvedCli auth status --json --verify 2>&1 | Out-String).Trim()
$authExit = $LASTEXITCODE
if ($authExit -ne 0) {
    throw "lark-cli auth verification failed with exit code $authExit."
}

try {
    $auth = $authRaw | ConvertFrom-Json -ErrorAction Stop
} catch {
    throw 'lark-cli auth status did not return parseable JSON. Check PowerShell UTF-8 initialization.'
}

$user = $auth.identities.user
if (($auth.verified -ne $true) -or ($null -eq $user) -or ($user.available -ne $true) -or ($user.verified -ne $true)) {
    throw 'A verified, available user identity is required.'
}

$mojibakePattern = '(?:\u951f\u65a4\u62f7|\u6d93\u5a42\u61c6|\u93c8\ue100\u61c6|\u7039\u5c7e\u579a|\u9352\u55db\u6685|\u6924\u572d\u6d30|\u5bb8\u30e4\u7d94|\ufffd)'
$captures = @()

foreach ($path in $JsonPath) {
    $resolvedPath = (Resolve-Path -LiteralPath $path).Path
    $bytes = [IO.File]::ReadAllBytes($resolvedPath)

    try {
        $raw = $strictUtf8.GetString($bytes)
    } catch {
        throw "Capture is not valid UTF-8: $resolvedPath"
    }

    if ([regex]::IsMatch($raw, $mojibakePattern)) {
        throw "Capture contains likely mojibake: $resolvedPath"
    }

    try {
        $parsed = $raw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        throw "Capture is not parseable JSON: $resolvedPath"
    }

    $propertyNames = @($parsed.PSObject.Properties.Name)
    if (($propertyNames -contains 'ok') -and ($parsed.ok -ne $true)) {
        throw "Capture contains an unsuccessful Lark API envelope: $resolvedPath"
    }

    $captures += [PSCustomObject]@{
        file = [IO.Path]::GetFileName($resolvedPath)
        utf8 = $true
        json = $true
        api_ok = if ($propertyNames -contains 'ok') { $true } else { $null }
    }
}

$summary = [PSCustomObject]@{
    ok = $true
    identity = 'user'
    verified = $true
    user_status = [string]$user.status
    captures_checked = $captures.Count
    captures = $captures
}

$summary | ConvertTo-Json -Depth 5
