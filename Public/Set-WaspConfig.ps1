function Set-WaspConfig {
    <#
    .SYNOPSIS
        Saves WASP AssetCloud connection settings for the current user.
    .DESCRIPTION
        Stores BaseUrl and/or API key under the per-user data directory.
        On Windows the key is DPAPI-encrypted; on other platforms it is stored with
        restrictive file permissions. You can also set WASP_API_KEY instead of -ApiKey.
    .PARAMETER BaseUrl
        Tenant root URL, e.g. https://contoso.waspassetcloud.com
        Do not use the /Help/Api documentation URL.
    .PARAMETER ApiKey
        Bearer token generated for an API user in AssetCloud.
    .EXAMPLE
        Set-WaspConfig -BaseUrl 'https://contoso.waspassetcloud.com' -ApiKey $token
    .EXAMPLE
        Set-WaspConfig -ApiKey $token
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Both')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Both')]
        [Parameter(Mandatory, ParameterSetName = 'BaseUrlOnly')]
        [string]$BaseUrl,

        [Parameter(Mandatory, ParameterSetName = 'Both')]
        [Parameter(Mandatory, ParameterSetName = 'ApiKeyOnly')]
        [string]$ApiKey
    )

    if ($PSBoundParameters.ContainsKey('BaseUrl')) {
        $trimmed = $BaseUrl.Trim().TrimEnd('/')
        try {
            $uri = [Uri]$trimmed
            if (-not $uri.IsAbsoluteUri -or $uri.Scheme -notin @('http', 'https')) {
                throw 'BaseUrl must be an absolute http/https URI.'
            }
        }
        catch {
            throw "Invalid BaseUrl '$BaseUrl'. Expected e.g. https://contoso.waspassetcloud.com"
        }

        if ($trimmed -match '/Help') {
            Write-Warning 'BaseUrl should be your tenant root (https://yourtenant.waspassetcloud.com), not the Help/Api docs page.'
        }

        $BaseUrl = $trimmed
    }

    $target = if ($PSBoundParameters.ContainsKey('BaseUrl')) { $BaseUrl } else { 'API key' }
    if ($PSCmdlet.ShouldProcess($target, 'Save Wasp AssetCloud configuration')) {
        if ($PSBoundParameters.ContainsKey('BaseUrl')) {
            Write-WaspConfig -BaseUrl $BaseUrl
            Write-Verbose "BaseUrl saved to $(Join-Path (Get-WaspDataPath) 'settings.json')"
        }

        if ($PSBoundParameters.ContainsKey('ApiKey')) {
            Save-WaspApiKey -ApiKey $ApiKey
            Write-Verbose 'API key saved for the current user.'
        }

        Write-Information 'Wasp configuration saved.' -InformationAction Continue
    }
}
