function Get-WaspConfig {
    <#
    .SYNOPSIS
        Shows the current WASP AssetCloud configuration (without revealing the API key).
    .EXAMPLE
        Get-WaspConfig
    #>
    [CmdletBinding()]
    param()

    $config = Read-WaspConfig
    $dataPath = Get-WaspDataPath
    $keyFile = Join-Path $dataPath 'ApiKey.secure'
    $hasEnvKey = -not [string]::IsNullOrWhiteSpace($env:WASP_API_KEY)
    $hasFileKey = Test-Path -LiteralPath $keyFile

    [pscustomobject]@{
        BaseUrl          = if ($config) { $config.BaseUrl } else { $null }
        DataPath         = $dataPath
        ApiKeyConfigured = ($hasEnvKey -or $hasFileKey)
        ApiKeySource     = if ($hasEnvKey) { 'Environment (WASP_API_KEY)' }
                           elseif ($hasFileKey) { 'User data file' }
                           else { 'None' }
    }
}
