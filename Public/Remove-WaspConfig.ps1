function Remove-WaspConfig {
    <#
    .SYNOPSIS
        Removes saved WASP AssetCloud configuration for the current user.
    .DESCRIPTION
        Deletes the per-user settings.json and/or ApiKey.secure files.
        Does not clear the WASP_API_KEY environment variable (if set).
    .PARAMETER ApiKey
        Remove only the stored API key file.
    .PARAMETER BaseUrl
        Remove only the saved BaseUrl settings file.
    .PARAMETER All
        Remove both settings and API key (default when no switch is specified).
    .EXAMPLE
        Remove-WaspConfig
    .EXAMPLE
        Remove-WaspConfig -ApiKey
    .EXAMPLE
        Remove-WaspConfig -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'All')]
    param(
        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory, ParameterSetName = 'ApiKeyOnly')]
        [switch]$ApiKey,

        [Parameter(Mandatory, ParameterSetName = 'BaseUrlOnly')]
        [switch]$BaseUrl
    )

    $dataPath = Get-WaspDataPath
    $settingsFile = Join-Path $dataPath 'settings.json'
    $keyFile = Join-Path $dataPath 'ApiKey.secure'

    $removeSettings = $PSCmdlet.ParameterSetName -in @('All', 'BaseUrlOnly')
    $removeKey = $PSCmdlet.ParameterSetName -in @('All', 'ApiKeyOnly')

    $targets = @()
    if ($removeSettings -and (Test-Path -LiteralPath $settingsFile)) {
        $targets += $settingsFile
    }
    if ($removeKey -and (Test-Path -LiteralPath $keyFile)) {
        $targets += $keyFile
    }

    if ($targets.Count -eq 0) {
        Write-Verbose "No matching Wasp config files found under '$dataPath'."
        if (-not [string]::IsNullOrWhiteSpace($env:WASP_API_KEY)) {
            Write-Warning 'WASP_API_KEY is still set in this session. Clear it with: Remove-Item Env:WASP_API_KEY'
        }
        return
    }

    foreach ($file in $targets) {
        if ($PSCmdlet.ShouldProcess($file, 'Remove Wasp AssetCloud config file')) {
            Remove-Item -LiteralPath $file -Force
            Write-Verbose "Removed '$file'."
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($env:WASP_API_KEY)) {
        Write-Warning 'WASP_API_KEY is still set in this session. Clear it with: Remove-Item Env:WASP_API_KEY'
    }
}
