[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ScriptUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$targetPath = Join-Path $env:TEMP 'deploy-singbox-transparent.ps1'

Write-Host ('Downloading deploy script from {0}' -f $ScriptUrl)
Invoke-WebRequest -Uri $ScriptUrl -OutFile $targetPath

Write-Host ('Saved to {0}' -f $targetPath)
Write-Host 'Starting deploy script...'

& powershell -ExecutionPolicy Bypass -File $targetPath
