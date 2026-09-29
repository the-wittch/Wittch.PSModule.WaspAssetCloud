function Format-WaspSiteInfo {
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
            SiteName        = $item.SiteName
            SiteDescription = $item.SiteDescription
            LocationCount   = $item.LocationCount
            SiteNotes       = $item.SiteNotes
            Raw             = $item
        }
    }
}
