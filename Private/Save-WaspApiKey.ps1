function Test-WaspWindowsPlatform {
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        return $true
    }
    if ($null -ne (Get-Variable -Name IsWindows -ErrorAction SilentlyContinue)) {
        return [bool]$IsWindows
    }
    return [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT
}

function Save-WaspApiKey {
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey
    )

    # Strip accidental whitespace / wrapping quotes from paste
    $apiKeyClean = $ApiKey.Trim() -replace '^["'']', '' -replace '["'']$', ''
    if ([string]::IsNullOrWhiteSpace($apiKeyClean)) {
        throw 'ApiKey cannot be empty.'
    }

    $keyFile = Join-Path (Get-WaspDataPath -Create) 'ApiKey.secure'

    if (Test-WaspWindowsPlatform) {
        $secureString = ConvertTo-SecureString -String $apiKeyClean -AsPlainText -Force
        $encrypted = ConvertFrom-SecureString $secureString
        Set-Content -LiteralPath $keyFile -Value $encrypted -Encoding UTF8
    }
    else {
        # DPAPI is Windows-only; store with restrictive permissions on Unix.
        Set-Content -LiteralPath $keyFile -Value $apiKeyClean -Encoding UTF8
        if (Get-Command -Name chmod -ErrorAction SilentlyContinue) {
            & chmod 600 -- $keyFile
        }
    }
}
