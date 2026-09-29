# Manual smoke test for Wittch.PSModule.WaspAssetCloud
# Requires a real tenant URL and API key. Not run by CI.

$ModulePath = Join-Path (Join-Path $PSScriptRoot '..') 'Wittch.PSModule.WaspAssetCloud.psd1'
Import-Module $ModulePath -Force

# Use your tenant root — not the /Help/Api documentation URL
Set-WaspConfig -BaseUrl 'https://yourtenant.waspassetcloud.com'
# Set-WaspConfig -BaseUrl 'https://yourtenant.waspassetcloud.com' -ApiKey (Read-Host 'API key')

Get-WaspConfig | Format-List

$tag = '12345'
Write-Host "Looking up asset tag: $tag" -ForegroundColor Cyan

Get-WaspAssetByTag -Tag $tag |
    Format-Table AssetTag, SerialNumber, Manufacturer, Model, AssetType, SiteName, AssetStatus -AutoSize

# Invoke-WaspAssetInfoSearch -SearchPattern $tag
# Get-WaspAssetCheckoutStatus -AssetTag $tag
# Find-WaspAssetType -SearchPattern 'Laptop' -AssetClass FixedAsset
# Find-WaspSite -SearchPattern ''
# Invoke-WaspAssetCheckOut -AssetTag $tag -AssigneeType Employee -AssigneeNumber 'E123' -WhatIf
# Invoke-WaspAssetCheckIn -AssetTag $tag -WhatIf
