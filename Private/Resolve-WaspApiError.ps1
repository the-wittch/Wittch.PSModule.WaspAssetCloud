function Resolve-WaspApiError {
    [CmdletBinding(DefaultParameterSetName = 'Exception')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Exception')]
        [System.Exception]$Exception,

        [Parameter(Mandatory, ParameterSetName = 'Response')]
        $ResponseObject,

        [switch]$Throw
    )

    # WASP API wrapper errors inside response object
    if ($PSCmdlet.ParameterSetName -eq 'Response') {
        $errors = @($ResponseObject.Messages | Select-Object Message, HttpStatusCode, ResultCode)

        Write-Error 'Wasp API reported errors:'
        foreach ($e in $errors) {
            Write-Error "[$($e.HttpStatusCode)] $($e.Message)"
        }

        if ($Throw) {
            throw ($errors | Format-List | Out-String)
        }

        return [pscustomobject]@{
            Success     = $false
            Errors      = $errors
            RawResponse = $ResponseObject
        }
    }

    $status = $null
    $desc = $null

    # Windows PowerShell: System.Net.WebException
    if ($Exception -is [System.Net.WebException] -and $Exception.Response) {
        $status = [int]$Exception.Response.StatusCode
        $desc = $Exception.Response.StatusDescription
    }
    # PowerShell 7+: HttpResponseException
    elseif ($Exception.Response -and $Exception.Response.StatusCode) {
        $status = [int]$Exception.Response.StatusCode
        $desc = [string]$Exception.Response.StatusCode
    }

    if ($null -ne $status) {
        $msg = "HTTP Error $status : $desc"
        Write-Error $msg

        if ($Throw) { throw $msg }

        return [pscustomobject]@{
            Success    = $false
            StatusCode = $status
            Message    = $desc
            Exception  = $Exception
        }
    }

    # Unexpected exceptions (parse errors, TLS, etc.)
    $msg = $Exception.Message
    Write-Error "Unexpected Wasp API error: $msg"

    if ($Throw) { throw $msg }

    return [pscustomobject]@{
        Success   = $false
        Message   = $msg
        Exception = $Exception
    }
}
