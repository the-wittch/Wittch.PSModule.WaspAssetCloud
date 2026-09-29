function Invoke-WaspAdvancedAssetInfoSearch {
    <#
    .SYNOPSIS
        Paged / filtered asset search (AssetCloud advanced asset info search).
    .DESCRIPTION
        Calls POST public-api/assets/assetadvancedinfosearch. Supports paging and a
        simple field filter. Pass -Raw to inspect the full response while building
        more complex Filter / _sortCriteria payloads for future wrappers.
    .PARAMETER SearchPattern
        Value applied to the filter (default field: AssetTag, operator: Equals).
    .PARAMETER Field
        Filter field name. Default: AssetTag.
    .PARAMETER Operator
        Filter operator. Default: Equals.
    .PARAMETER PageSize
        Page size (WASP recommends ~100). Default: 100.
    .PARAMETER PageNumber
        1-based page number. Default: 1.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Invoke-WaspAdvancedAssetInfoSearch -SearchPattern 'LAPTOP-001'
    .EXAMPLE
        Invoke-WaspAdvancedAssetInfoSearch -SearchPattern 'Dell' -Field AssetDescription -Operator Contains -PageSize 50
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-assets-assetadvancedinfosearch
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('AssetTag')]
        [string]$SearchPattern,

        [string]$Field = 'AssetTag',

        [ValidateSet('Equals', 'Contains', 'StartsWith', 'EndsWith', 'NotEquals')]
        [string]$Operator = 'Equals',

        [ValidateRange(1, 500)]
        [int]$PageSize = 100,

        [ValidateRange(1, [int]::MaxValue)]
        [int]$PageNumber = 1,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $body = @{
            _sortCriteria            = @()
            TotalCountFromPriorFetch = 0
            AdditionalSkipCount      = 0
            PageSize                 = $PageSize
            PageNumber               = $PageNumber
            Filter                   = @{
                field    = $Field
                operator = $Operator
                value    = $SearchPattern
                logic    = $null
                filters  = @()
            }
            ClientUtcOffset          = $null
            FilterBehavior           = 0
            IgnoreAttachments        = $true
            IgnoreGeoLocation        = $true
            WorkingSiteIdCsvList     = ''
        }

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/assets/assetadvancedinfosearch' `
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
