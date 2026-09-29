@{
    RootModule        = 'Wittch.PSModule.WaspAssetCloud.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'c9e4b898-3fd2-4f9a-bbd8-78c2840bd2db'
    Author            = 'Wittch'
    CompanyName       = 'Wittch'
    Copyright         = '(c) Wittch. All rights reserved.'
    Description       = 'PowerShell module for interacting with Wasp AssetCloud REST APIs.'
    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        'Set-WaspConfig'
        'Get-WaspConfig'
        'Remove-WaspConfig'
        'Get-WaspAssetByTag'
        'Invoke-WaspAssetInfoSearch'
        'Invoke-WaspAdvancedAssetInfoSearch'
        'Get-WaspAssetCheckoutStatus'
        'Get-WaspEmployeeCheckoutStatus'
        'Get-WaspCustomerCheckoutStatus'
        'Find-WaspAssetType'
        'Find-WaspSite'
        'Invoke-WaspAssetCheckOut'
        'Invoke-WaspAssetCheckIn'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags       = @('WaspAssetCloud', 'Wittch', 'API', 'Wasp', 'Assets')
            ProjectUri = 'https://github.com/the-wittch/Wittch.PSModule.WaspAssetCloud'
            LicenseUri = 'https://github.com/the-wittch/Wittch.PSModule.WaspAssetCloud/blob/main/LICENSE'
        }
    }
}
