function Invoke-WaspApi {
    <#
        Shared REST client for all public WASP endpoint wrappers.
        Add new Public/*.ps1 cmdlets that call this helper rather than
        invoking Invoke-RestMethod directly.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [string]$Method = 'POST',

        [object]$Body,

        [ValidateRange(1, 600)]
        [int]$TimeoutSec = 60,

        [switch]$ThrowOnError
    )

    $config = Read-WaspConfig
    if (-not $config -or [string]::IsNullOrWhiteSpace($config.BaseUrl)) {
        throw 'Configuration missing or BaseUrl is empty. Run Set-WaspConfig -BaseUrl https://yourtenant.waspassetcloud.com'
    }

    if ($config.BaseUrl -match 'waspassetcloud\.com/Help' -or $config.BaseUrl -match 'yourtenant') {
        Write-Warning "BaseUrl looks like a docs/placeholder URL ('$($config.BaseUrl)'). Use your tenant root, e.g. https://contoso.waspassetcloud.com"
    }

    $apiKey = Get-WaspApiKey

    $base = $config.BaseUrl.TrimEnd('/')
    $path = $Endpoint.TrimStart('/')
    $uri = "$base/$path"

    $version = '1.0.0'
    if ($MyInvocation.MyCommand.Module -and $MyInvocation.MyCommand.Module.Version) {
        $version = $MyInvocation.MyCommand.Module.Version.ToString()
    }

    $headers = @{
        Authorization = "Bearer $apiKey"
        'User-Agent'  = "$script:WaspModuleName/$version"
    }

    $irmParams = @{
        Uri         = $uri
        Method      = $Method
        Headers     = $headers
        TimeoutSec  = $TimeoutSec
        ErrorAction = 'Stop'
    }

    if ($null -ne $Body) {
        $irmParams['ContentType'] = 'application/json; charset=utf-8'
        if ($Body -is [string]) {
            $irmParams['Body'] = $Body
        }
        else {
            # Use -InputObject so single-element arrays stay JSON arrays (PS 5.1 pipeline unwraps them)
            $irmParams['Body'] = ConvertTo-Json -InputObject $Body -Depth 10 -Compress
        }
    }

    Write-Verbose "$Method $uri"
    try {
        $response = Invoke-RestMethod @irmParams

        if ($response.HasError -eq $true) {
            return Resolve-WaspApiError -ResponseObject $response -Throw:$ThrowOnError
        }

        return $response
    }
    catch {
        return Resolve-WaspApiError -Exception $_.Exception -Throw:$ThrowOnError
    }
}
