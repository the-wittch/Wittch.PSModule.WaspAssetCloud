function Get-WaspAssetCheckoutStatus {
    <#
    .SYNOPSIS
        Gets checkout information for an asset tag.
    .DESCRIPTION
        Calls GET public-api/assets/checkout-status/{AssetTag}.
        One entry is returned per open checkout. An asset that is not checked out
        returns no data rather than an error.
    .PARAMETER AssetTag
        Asset tag to query.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Get-WaspAssetCheckoutStatus -AssetTag 'LAPTOP-001'
    .LINK
        https://www.waspassetcloud.com/Help/Api/GET-public-api-assets-checkout-status-AssetTag
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Tag')]
        [string]$AssetTag,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $encoded = [uri]::EscapeDataString($AssetTag.Trim())
        $response = Invoke-WaspApi `
            -Endpoint "public-api/assets/checkout-status/$encoded" `
            -Method GET `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspCheckoutStatus -Response $response -RequestedId $AssetTag
    }
}
