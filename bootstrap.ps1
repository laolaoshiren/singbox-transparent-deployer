[CmdletBinding()]
param(
    [string]$ScriptUrl = 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    if (([Net.ServicePointManager]::SecurityProtocol -band [Net.SecurityProtocolType]::Tls12) -eq 0) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
}
catch {
}

$targetPath = Join-Path $env:TEMP 'deploy-singbox-transparent.ps1'
Write-Host ('Downloading deploy script from {0}' -f $ScriptUrl)

try {
    Invoke-WebRequest -UseBasicParsing -Uri $ScriptUrl -OutFile $targetPath
}
catch {
    throw 'Failed to download deploy script from GitHub. Check HTTPS access to raw.githubusercontent.com.'
}

Write-Host ('Saved to {0}' -f $targetPath)
Write-Host 'Starting deploy script...'
& powershell -ExecutionPolicy Bypass -File $targetPath
