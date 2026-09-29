function Format-WaspAssetTypeInfo {
    param(
        [Parameter(Mandatory)]
        $Response
    )

    $dataList = Get-WaspResponseData -Response $Response
    if (-not $dataList -or $dataList.Count -eq 0) {
        return @()
    }

    foreach ($item in $dataList) {
        [pscustomobject]@{
            AssetTypeNumber      = $item.AssetTypeNumber
            AssetTypeDescription = $item.AssetTypeDescription
            AssetClass           = $item.AssetClass
            ManufacturerName     = $item.ManufacturerName
            CategoryDescription  = $item.CategoryDescription
            ModelNumber          = $item.AssetTypeModelNumber
            AssetCount           = $item.AssetCount
            HasAttachment        = $item.HasAttachment
            Raw                  = $item
        }
    }
}
