[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ScriptUrl,
    [string]$Language = 'zh-CN'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$normalizedLanguage = ''
if ($null -ne $Language) {
    $normalizedLanguage = $Language.Trim().ToLowerInvariant()
}

$resolvedLanguage = switch ($normalizedLanguage) {
    'en' { 'en-US' }
    'en-us' { 'en-US' }
    default { 'zh-CN' }
}

$targetPath = Join-Path $env:TEMP 'deploy-singbox-transparent.ps1'

if ($resolvedLanguage -eq 'en-US') {
    Write-Host ('Downloading deploy script from {0}' -f $ScriptUrl)
}
else {
    Write-Host ('正在从 {0} 下载部署脚本' -f $ScriptUrl)
}

Invoke-WebRequest -Uri $ScriptUrl -OutFile $targetPath

if ($resolvedLanguage -eq 'en-US') {
    Write-Host ('Saved to {0}' -f $targetPath)
    Write-Host 'Starting deploy script...'
}
else {
    Write-Host ('已保存到 {0}' -f $targetPath)
    Write-Host '正在启动部署脚本...'
}

& powershell -ExecutionPolicy Bypass -File $targetPath -Language $resolvedLanguage
