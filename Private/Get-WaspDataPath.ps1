function Get-WaspDataPath {
    <#
        Returns the per-user data directory for config and credentials.
        Never writes under the module install path (Program Files / Modules).
    #>
    [CmdletBinding()]
    param(
        [switch]$Create
    )

    if ($env:LOCALAPPDATA) {
        $root = Join-Path $env:LOCALAPPDATA $script:WaspModuleName
    }
    elseif ($env:XDG_CONFIG_HOME) {
        $root = Join-Path $env:XDG_CONFIG_HOME $script:WaspModuleName
    }
    else {
        $root = Join-Path (Join-Path $HOME '.config') $script:WaspModuleName
    }

    if ($Create -and -not (Test-Path -LiteralPath $root)) {
        New-Item -ItemType Directory -Path $root -Force | Out-Null
    }

    return $root
}
