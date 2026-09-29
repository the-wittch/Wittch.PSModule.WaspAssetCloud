<#
    .SYNOPSIS
        WASP AssetCloud PowerShell Module
    .DESCRIPTION
        Loads Public/Private functions for the WASP AssetCloud REST API.
    .NOTES
        Version: 1.0.0
        Author:  Wittch
#>

$script:WaspModuleRoot = $PSScriptRoot
$script:WaspModuleName = 'Wittch.PSModule.WaspAssetCloud'

# Dot-source at module scope (not inside a function) so cmdlets are exported.
# A foreach STATEMENT keeps the current scope; wrapping . in a helper function would not.
foreach ($scriptFile in @(
        Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter '*.ps1' -ErrorAction Stop | Sort-Object Name
    )) {
    try {
        . $scriptFile.FullName
    }
    catch {
        throw "Failed to load module script '$($scriptFile.Name)': $($_.Exception.Message)"
    }
}

foreach ($scriptFile in @(
        Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1' -ErrorAction Stop | Sort-Object Name
    )) {
    try {
        . $scriptFile.FullName
    }
    catch {
        throw "Failed to load module script '$($scriptFile.Name)': $($_.Exception.Message)"
    }
}
