[CmdletBinding()]
param(
    [string]$ScriptUrl = 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1',
    [string]$Language = ''
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

$normalizedLanguage = ''
if ($null -ne $Language) {
    $normalizedLanguage = $Language.Trim().ToLowerInvariant()
}

$resolvedLanguage = switch ($normalizedLanguage) {
    'en' { 'en-US' }
    'en-us' { 'en-US' }
    'zh' { 'zh-CN' }
    'zh-cn' { 'zh-CN' }
    '' { '' }
    default { 'zh-CN' }
}

$targetPath = Join-Path $env:TEMP 'deploy-singbox-transparent.ps1'
$downloadUrls = @($ScriptUrl)
if ($ScriptUrl -match '^https://raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.+)$') {
    $downloadUrls += ('https://cdn.jsdelivr.net/gh/{0}/{1}@{2}/{3}' -f $Matches[1], $Matches[2], $Matches[3], $Matches[4])
}

if ($resolvedLanguage -eq 'en-US') {
    Write-Host ('Downloading deploy script from {0}' -f $ScriptUrl)
}
elseif ($resolvedLanguage -eq 'zh-CN') {
    Write-Host ('正在从 {0} 下载部署脚本' -f $ScriptUrl)
}
else {
    Write-Host ('Downloading deploy script / 正在下载部署脚本: {0}' -f $ScriptUrl)
}

foreach ($url in ($downloadUrls | Select-Object -Unique)) {
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $targetPath
        break
    }
    catch {
        try {
            curl.exe -L --max-time 60 -o $targetPath $url | Out-Null
            if (Test-Path $targetPath) {
                break
            }
        }
        catch {
        }
    }
}

if (-not (Test-Path $targetPath)) {
    throw 'Unable to download the deploy script.'
}

if ($resolvedLanguage -eq 'en-US') {
    Write-Host ('Saved to {0}' -f $targetPath)
    Write-Host 'Starting deploy script...'
}
elseif ($resolvedLanguage -eq 'zh-CN') {
    Write-Host ('已保存到 {0}' -f $targetPath)
    Write-Host '正在启动部署脚本...'
}
else {
    Write-Host ('Saved to {0}' -f $targetPath)
    Write-Host 'Starting deploy script / 正在启动部署脚本...'
}

if ([string]::IsNullOrWhiteSpace($resolvedLanguage)) {
    & powershell -ExecutionPolicy Bypass -File $targetPath
}
else {
    & powershell -ExecutionPolicy Bypass -File $targetPath -Language $resolvedLanguage
}
