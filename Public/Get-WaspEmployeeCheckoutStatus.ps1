function Get-WaspEmployeeCheckoutStatus {
    <#
    .SYNOPSIS
        Gets assets currently checked out to an employee.
    .DESCRIPTION
        Calls GET public-api/employees/checkout-status/{EmployeeNumber}.
        Optimized for employee number; can also match on employee name.
    .PARAMETER EmployeeNumber
        Employee number (or name fragment matched by the API).
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Get-WaspEmployeeCheckoutStatus -EmployeeNumber 'E12345'
    .LINK
        https://www.waspassetcloud.com/Help/Api/GET-public-api-employees-checkout-status-EmployeeNumber
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Number')]
        [string]$EmployeeNumber,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $encoded = [uri]::EscapeDataString($EmployeeNumber.Trim())
        $response = Invoke-WaspApi `
            -Endpoint "public-api/employees/checkout-status/$encoded" `
            -Method GET `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspCheckoutStatus -Response $response -RequestedId $EmployeeNumber
    }
}
