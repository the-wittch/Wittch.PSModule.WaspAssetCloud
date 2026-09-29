function Get-WaspAssetByTag {
    <#
    .SYNOPSIS
        Gets assets by exact asset tag(s).
    .DESCRIPTION
        Calls POST public-api/assets/getAssetsByTags with a JSON array of tags.
        Unlike Invoke-WaspAssetInfoSearch, this is an exact tag match and returns
        fuller asset records (including attachments/custom fields).
    .PARAMETER Tag
        One or more asset tags. Accepts pipeline input.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Get-WaspAssetByTag -Tag 'LAPTOP-001'
    .EXAMPLE
        'LAPTOP-001','LAPTOP-002' | Get-WaspAssetByTag
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-assets-getAssetsByTags
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('AssetTag')]
        [string[]]$Tag,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    begin {
        $tags = New-Object System.Collections.Generic.List[string]
    }

    process {
        foreach ($t in $Tag) {
            if (-not [string]::IsNullOrWhiteSpace($t)) {
                [void]$tags.Add($t.Trim())
            }
        }
    }

    end {
        if ($tags.Count -eq 0) {
            throw 'At least one non-empty Tag is required.'
        }

        $body = @($tags.ToArray())

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/assets/getAssetsByTags' `
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
