function Format-WaspCheckoutStatus {
    param(
        [Parameter(Mandatory)]
        $Response,

        [string]$RequestedId
    )

    $dataList = Get-WaspResponseData -Response $Response
    if (-not $dataList -or $dataList.Count -eq 0) {
        return @()
    }

    foreach ($item in $dataList) {
        [pscustomobject]@{
            RequestedId      = $RequestedId
            AssetTag         = $item.AssetTag
            AssetDescription = $item.AssetDescription
            Quantity         = $item.Quantity
            SiteName         = $item.SiteName
            LocationCode     = $item.LocationCode
            AssigneeName     = $(
                if ($item.EmployeeName) { $item.EmployeeName }
                elseif ($item.CustomerName) { $item.CustomerName }
                elseif ($item.OwnerName) { $item.OwnerName }
                else { $null }
            )
            AssigneeNumber   = $(
                if ($item.EmployeeNumber) { $item.EmployeeNumber }
                elseif ($item.CustomerNumber) { $item.CustomerNumber }
                elseif ($item.OwnerNumber) { $item.OwnerNumber }
                else { $null }
            )
            CheckOutDate     = $(
                if ($item.CheckOutDate) { $item.CheckOutDate }
                elseif ($item.CheckoutDate) { $item.CheckoutDate }
                elseif ($item.TransactionDate) { $item.TransactionDate }
                else { $null }
            )
            DueDate          = $item.DueDate
            Raw              = $item
        }
    }
}
