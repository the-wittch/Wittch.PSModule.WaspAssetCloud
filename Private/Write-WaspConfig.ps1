function Write-WaspConfig {
    param(
        [Parameter(Mandatory)]
        [string]$BaseUrl
    )

    $configFile = Join-Path (Get-WaspDataPath -Create) 'settings.json'
    $config = @{
        BaseUrl = $BaseUrl.Trim().TrimEnd('/')
    }

    $config | ConvertTo-Json | Set-Content -LiteralPath $configFile -Encoding UTF8
}
