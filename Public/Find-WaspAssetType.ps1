function Find-WaspAssetType {
    <#
    .SYNOPSIS
        Searches asset types by number or description.
    .DESCRIPTION
        Calls POST public-api/asset-types/infosearch.
    .PARAMETER SearchPattern
        Text matched against asset type number or description. Empty returns up to the API page limit.
    .PARAMETER AssetClass
        Unknown (0), FixedAsset (1), or InventoryAsset (2). Default: Unknown.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Find-WaspAssetType -SearchPattern 'Laptop'
    .EXAMPLE
        Find-WaspAssetType -SearchPattern 'LAP' -AssetClass FixedAsset
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-asset-types-infosearch
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [AllowEmptyString()]
        [string]$SearchPattern = '',

        [ValidateSet('Unknown', 'FixedAsset', 'InventoryAsset')]
        [string]$AssetClass = 'Unknown',

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $assetClassValue = switch ($AssetClass) {
            'FixedAsset' { 1 }
            'InventoryAsset' { 2 }
            default { 0 }
        }

        $body = @{
            SearchPattern = $SearchPattern
            AssetClass    = $assetClassValue
        }

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/asset-types/infosearch' `
            -Method POST `
            -Body $body `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspAssetTypeInfo -Response $response
    }
}
