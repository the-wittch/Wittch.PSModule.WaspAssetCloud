function Find-WaspSite {
    <#
    .SYNOPSIS
        Searches sites by name or description.
    .DESCRIPTION
        Calls POST public-api/sites/infosearch.
    .PARAMETER SearchPattern
        Text matched against site name or description. Empty may return active sites (API-capped).
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Find-WaspSite -SearchPattern 'Chicago'
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-sites-infosearch
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [AllowEmptyString()]
        [string]$SearchPattern = '',

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $body = @{
            SearchPattern = $SearchPattern
        }

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/sites/infosearch' `
            -Method POST `
            -Body $body `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspSiteInfo -Response $response
    }
}
