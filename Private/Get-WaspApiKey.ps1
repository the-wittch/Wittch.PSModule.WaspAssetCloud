function Get-WaspApiKey {
    # Prefer environment variable for CI / automation (never logged by this module)
    if (-not [string]::IsNullOrWhiteSpace($env:WASP_API_KEY)) {
        return $env:WASP_API_KEY.Trim()
    }

    $keyFile = Join-Path (Get-WaspDataPath) 'ApiKey.secure'
    if (-not (Test-Path -LiteralPath $keyFile)) {
        throw "No API key configured. Run Set-WaspConfig -ApiKey <key> or set the WASP_API_KEY environment variable."
    }

    $stored = (Get-Content -LiteralPath $keyFile -Raw -Encoding UTF8).Trim()
    if ([string]::IsNullOrWhiteSpace($stored)) {
        throw "API key file is empty. Run Set-WaspConfig -ApiKey <key>."
    }

    if (Test-WaspWindowsPlatform) {
        try {
            $secureString = ConvertTo-SecureString -String $stored
            return [System.Net.NetworkCredential]::new('', $secureString).Password
        }
        catch {
            throw "Failed to decrypt stored API key. Re-save it with Set-WaspConfig -ApiKey <key>. $($_.Exception.Message)"
        }
    }

    return $stored
}
