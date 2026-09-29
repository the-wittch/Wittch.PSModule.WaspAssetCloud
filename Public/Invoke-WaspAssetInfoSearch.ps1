function Invoke-WaspAssetInfoSearch {
    <#
    .SYNOPSIS
        Searches assets by tag or description (AssetCloud asset lookup).
    .DESCRIPTION
        Calls POST public-api/assets/assetinfosearch. Returns asset-level fields only;
        site/location/checkout are not populated. Use Invoke-WaspAdvancedAssetInfoSearch
        when you need those values or paging/filters.
    .PARAMETER SearchPattern
        Text matched against asset tag or description.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Invoke-WaspAssetInfoSearch -SearchPattern 'LAPTOP-001'
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-assets-assetinfosearch
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('AssetTag')]
        [string]$SearchPattern,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $body = @{ SearchPattern = $SearchPattern }

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/assets/assetinfosearch' `
            -Method POST `
            -Body $body `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspAssetInfo -Response $response
    }
}
