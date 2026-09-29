function New-WaspTransactionBatch {
    <#
        Builds a TransactionBatchRequestModel for check-out / check-in / move / etc.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$AssetTag,

        [ValidateSet('Employee', 'Customer', 'Vendor')]
        [string]$AssigneeType,

        [string]$AssigneeNumber,

        [string]$Site,

        [string]$Location,

        [decimal]$Quantity = 1,

        [decimal]$UnitCost = 0,

        [string]$Comment,

        [string]$ClientDeviceId
    )

    $other = $null
    if ($AssigneeType -or $Comment) {
        $other = @{}
        if ($Comment) {
            $other['Comments'] = $Comment
        }
        if ($AssigneeType -and $AssigneeNumber) {
            switch ($AssigneeType) {
                'Employee' { $other['EmployeeNumber'] = $AssigneeNumber }
                'Customer' { $other['CustomerNumber'] = $AssigneeNumber }
                'Vendor'   { $other['VendorNumber'] = $AssigneeNumber }
            }
        }
    }

    $spacial = $null
    if ($Site -or $Location) {
        $spacial = @{
            Site     = $Site
            Location = $Location
        }
    }

    $requests = foreach ($tag in $AssetTag) {
        if ([string]::IsNullOrWhiteSpace($tag)) { continue }
        $req = @{
            AssetItemNumber = $tag.Trim()
            Quantity        = $Quantity
            UnitCost        = $UnitCost
        }
        if ($spacial) { $req['SpacialLocation'] = $spacial }
        if ($other) { $req['Other'] = $other }
        $req
    }

    $batch = @{
        Requests = @($requests)
    }
    if ($ClientDeviceId) {
        $batch['ClientDeviceId'] = $ClientDeviceId
    }

    return $batch
}
