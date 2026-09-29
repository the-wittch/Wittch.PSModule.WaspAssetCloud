function Get-WaspCustomerCheckoutStatus {
    <#
    .SYNOPSIS
        Gets assets currently checked out to a customer.
    .DESCRIPTION
        Calls GET public-api/customers/checkout-status/{CustomerNumber}.
        Matches exact customer number first, then partial number/name heuristics.
    .PARAMETER CustomerNumber
        Customer number (or name fragment matched by the API).
    .PARAMETER Raw
        Return the API response object without formatting.
    .PARAMETER ThrowOnError
        Throw terminating errors instead of returning a structured failure object.
    .EXAMPLE
        Get-WaspCustomerCheckoutStatus -CustomerNumber 'C100'
    .LINK
        https://www.waspassetcloud.com/Help/Api/GET-public-api-customers-checkout-status-CustomerNumber
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Number')]
        [string]$CustomerNumber,

        [switch]$ThrowOnError,

        [switch]$Raw
    )

    process {
        $encoded = [uri]::EscapeDataString($CustomerNumber.Trim())
        $response = Invoke-WaspApi `
            -Endpoint "public-api/customers/checkout-status/$encoded" `
            -Method GET `
            -ThrowOnError:$ThrowOnError

        if ($Raw) {
            return $response
        }

        if ($response.Success -eq $false) {
            return $response
        }

        return Format-WaspCheckoutStatus -Response $response -RequestedId $CustomerNumber
    }
}
