function Invoke-WaspAssetCheckIn {
    <#
    .SYNOPSIS
        Checks in one or more assets.
    .DESCRIPTION
        Calls POST public-api/transactions/public/asset/check-in.
        For fixed assets, Site/Location/Quantity are typically optional.
    .PARAMETER AssetTag
        Asset tag(s) to check in.
    .PARAMETER Site
        Optional site name (mainly for multi-quantity assets).
    .PARAMETER Location
        Optional location code (mainly for multi-quantity assets).
    .PARAMETER Quantity
        Quantity (default 1). Required for multi-quantity assets.
    .PARAMETER Comment
        Optional transaction comment.
    .PARAMETER ClientDeviceId
        Optional client device identifier recorded with the batch.
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Invoke-WaspAssetCheckIn -AssetTag 'LAPTOP-001'
    .LINK
        https://www.waspassetcloud.com/Help/Api/POST-public-api-transactions-public-asset-check-in
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Tag')]
        [string[]]$AssetTag,

        [string]$Site,

        [string]$Location,

        [decimal]$Quantity = 1,

        [string]$Comment,

        [string]$ClientDeviceId,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    begin {
        $tags = New-Object System.Collections.Generic.List[string]
    }

    process {
        foreach ($t in $AssetTag) {
            if (-not [string]::IsNullOrWhiteSpace($t)) {
                [void]$tags.Add($t.Trim())
            }
        }
    }

    end {
        if ($tags.Count -eq 0) {
            throw 'At least one AssetTag is required.'
        }

        $batch = New-WaspTransactionBatch `
            -AssetTag $tags.ToArray() `
            -Site $Site `
            -Location $Location `
            -Quantity $Quantity `
            -Comment $Comment `
            -ClientDeviceId $ClientDeviceId

        $target = ($tags -join ', ')
        if (-not $PSCmdlet.ShouldProcess($target, 'Check in asset(s)')) {
            return
        }

        $response = Invoke-WaspApi `
            -Endpoint 'public-api/transactions/public/asset/check-in' `
            -Method POST `
            -Body $batch `
            -ThrowOnError:$ThrowOnError

        if ($Raw -or $response.Success -eq $false) {
            return $response
        }

        return Get-WaspResponseData -Response $response
    }
}
