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

function Import-WaspScript {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$Path
    )

    try {
        . $Path.FullName
    }
    catch {
        throw "Failed to load module script '$($Path.Name)': $($_.Exception.Message)"
    }
}

Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter '*.ps1' -ErrorAction Stop |
    Sort-Object Name |
    ForEach-Object { Import-WaspScript -Path $_ }

Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1' -ErrorAction Stop |
    Sort-Object Name |
    ForEach-Object { Import-WaspScript -Path $_ }
