function Format-WaspAssetInfo {
    param(
        [Parameter(Mandatory)]
        $Response
    )

    $dataList = Get-WaspResponseData -Response $Response
    if (-not $dataList -or $dataList.Count -eq 0) {
        return @()
    }

    foreach ($item in $dataList) {
        # getAssetsByTags returns List<WaspResult<AssetInfo>> — unwrap successful rows
        if ($null -ne $item.PSObject.Properties['HasError'] -and $null -ne $item.PSObject.Properties['Data']) {
            if ($item.HasError -eq $true) {
                [pscustomobject]@{
                    Success  = $false
                    Messages = $item.Messages
                    Raw      = $item
                }
                continue
            }
            $item = $item.Data
            if (-not $item) { continue }
        }

        $customFieldHash = @{}
        if ($item.CustomFields) {
            foreach ($cf in $item.CustomFields) {
                $customFieldHash[$cf.DcfLabel] = $cf.DcfTextValue
            }
        }

        [pscustomobject]@{
            AssetTag         = $item.AssetTag
            AssetDescription = $item.AssetDescription
            SerialNumber     = $item.AssetSerialNumber
            Manufacturer     = $item.ManufacturerName
            Model            = $item.AssetModelName
            AssetType        = $item.AssetTypeNumber
            Condition        = $item.ConditionDescription
            SiteName         = $item.SiteName
            LocationCode     = $item.LocationCode
            OwnerName        = $item.OwnerName
            OwnerNumber      = $item.OwnerNumber
            HasAttachment    = $item.HasAttachment
            AssetStatus      = $customFieldHash['Asset Status']
            CustomFields     = $customFieldHash
            Raw              = $item
        }
    }
}

function Get-WaspResponseData {
    param($Response)

    if ($null -eq $Response) {
        return @()
    }

    if ($Response -is [System.Collections.IEnumerable] -and
        -not ($Response -is [string]) -and
        -not ($Response.PSObject.Properties.Name -contains 'Data')) {
        return @($Response)
    }

    if ($null -eq $Response.Data) {
        return @()
    }

    return @($Response.Data)
}
