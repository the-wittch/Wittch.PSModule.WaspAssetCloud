function Read-WaspConfig {
    $userConfig = Join-Path (Get-WaspDataPath) 'settings.json'
    if (Test-Path -LiteralPath $userConfig) {
        return (Get-Content -LiteralPath $userConfig -Raw -Encoding UTF8 | ConvertFrom-Json)
    }

    $defaultConfig = Join-Path $script:WaspModuleRoot 'Config/settings.json'
    if (Test-Path -LiteralPath $defaultConfig) {
        return (Get-Content -LiteralPath $defaultConfig -Raw -Encoding UTF8 | ConvertFrom-Json)
    }

    return $null
}
