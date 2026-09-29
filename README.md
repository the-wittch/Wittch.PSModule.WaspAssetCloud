# Wittch.PSModule.WaspAssetCloud

PowerShell module for the [WASP AssetCloud](https://www.waspassetcloud.com/Help/Api) REST API.

## Requirements

- PowerShell 5.1 or PowerShell 7+
- Your AssetCloud **tenant URL** and an **API token**

## Install

Clone or copy this repo into a PowerShell modules folder:

| PowerShell | Path |
|---|---|
| Windows PowerShell 5.1 | `$HOME\Documents\WindowsPowerShell\Modules\Wittch.PSModule.WaspAssetCloud` |
| PowerShell 7+ | `$HOME\Documents\PowerShell\Modules\Wittch.PSModule.WaspAssetCloud` |

Or import directly from the repo:

```powershell
Import-Module .\Wittch.PSModule.WaspAssetCloud.psd1 -Force
```

## Configure

`BaseUrl` is your **tenant root**, not the docs site:

- Correct: `https://contoso.waspassetcloud.com`
- Wrong: `https://www.waspassetcloud.com/Help/Api`

```powershell
# Save tenant URL + API key for the current user
Set-WaspConfig -BaseUrl 'https://contoso.waspassetcloud.com' -ApiKey (Read-Host 'API key')

# Or set them separately
Set-WaspConfig -BaseUrl 'https://contoso.waspassetcloud.com'
Set-WaspConfig -ApiKey 'your-token'

# Or use an environment variable (handy for CI / automation)
$env:WASP_API_KEY = 'your-token'
```

Settings and keys are stored per user (not inside the module folder):

- Windows: `%LOCALAPPDATA%\Wittch.PSModule.WaspAssetCloud\`
- Linux/macOS: `~/.config/Wittch.PSModule.WaspAssetCloud\`

```powershell
Get-WaspConfig
Remove-WaspConfig              # both settings + key (confirms first)
Remove-WaspConfig -ApiKey      # key file only
Remove-WaspConfig -BaseUrl     # settings.json only
```

## Usage

```powershell
# Exact tag lookup (one or many)
Get-WaspAssetByTag -Tag 'LAPTOP-001'
'LAPTOP-001','LAPTOP-002' | Get-WaspAssetByTag

# Fuzzy search (tag or description contains text)
Invoke-WaspAssetInfoSearch -SearchPattern 'LAPTOP'

# Paged / filtered search
Invoke-WaspAdvancedAssetInfoSearch -SearchPattern 'Dell' -Field AssetDescription -Operator Contains

# Checkout status
Get-WaspAssetCheckoutStatus -AssetTag 'LAPTOP-001'
Get-WaspEmployeeCheckoutStatus -EmployeeNumber 'E12345'
Get-WaspCustomerCheckoutStatus -CustomerNumber 'C100'

# Reference data
Find-WaspAssetType -SearchPattern 'Laptop' -AssetClass FixedAsset
Find-WaspSite -SearchPattern 'Chicago'

# Check-out / check-in (supports -WhatIf)
Invoke-WaspAssetCheckOut -AssetTag 'LAPTOP-001' -AssigneeType Employee -AssigneeNumber 'E12345'
Invoke-WaspAssetCheckIn -AssetTag 'LAPTOP-001'
```

### Cmdlets

| Cmdlet | Purpose |
|---|---|
| `Set-WaspConfig` | Save BaseUrl and/or API key |
| `Get-WaspConfig` | Show current config (no secret values) |
| `Remove-WaspConfig` | Delete saved settings and/or API key |
| `Get-WaspAssetByTag` | Exact asset lookup by tag(s) |
| `Invoke-WaspAssetInfoSearch` | Quick asset contains-search |
| `Invoke-WaspAdvancedAssetInfoSearch` | Paged/filtered asset search |
| `Get-WaspAssetCheckoutStatus` | Who has this asset checked out |
| `Get-WaspEmployeeCheckoutStatus` | Assets checked out to an employee |
| `Get-WaspCustomerCheckoutStatus` | Assets checked out to a customer |
| `Find-WaspAssetType` | Search asset types |
| `Find-WaspSite` | Search sites |
| `Invoke-WaspAssetCheckOut` | Check out asset(s) |
| `Invoke-WaspAssetCheckIn` | Check in asset(s) |

## Adding more WASP APIs

1. Add a script under `Public/` that builds a request body and calls private `Invoke-WaspApi -Endpoint 'public-api/...'`.
2. Add the function name to `FunctionsToExport` in `Wittch.PSModule.WaspAssetCloud.psd1`.
3. Prefer approved verbs (`Get-`, `Find-`, `New-`, `Set-`, `Remove-`) when they fit.

API catalog: [WASP AssetCloud API](https://www.waspassetcloud.com/Help/Api)

## References

- [WASP AssetCloud C# examples](https://dl.waspbarcode.com/kb/cloud/WaspCSAPI-20180803.zip)
- [API FAQ](https://support.waspbarcode.com/kb/articles/assetcloud-inventorycloud-api-faq)

## License

MIT — see [LICENSE](LICENSE).
