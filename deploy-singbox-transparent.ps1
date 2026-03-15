[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Read-RequiredValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [string]$Default = ''
    )

    while ($true) {
        $display = $Prompt
        if ($Default) {
            $display = '{0} [{1}]' -f $Prompt, $Default
        }

        $value = Read-Host $display
        if ([string]::IsNullOrWhiteSpace($value)) {
            $value = $Default
        }

        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value.Trim()
        }
    }
}

function Read-OptionalValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [string]$Default = ''
    )

    $display = $Prompt
    if ($Default) {
        $display = '{0} [{1}]' -f $Prompt, $Default
    }

    $value = Read-Host $display
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $Default
    }

    return $value.Trim()
}

function Read-ChoiceValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [Parameter(Mandatory = $true)]
        [string[]]$Choices,
        [string]$Default = ''
    )

    $normalizedChoices = $Choices | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    while ($true) {
        Write-Host $Prompt
        for ($i = 0; $i -lt $normalizedChoices.Count; $i++) {
            $choice = $normalizedChoices[$i]
            $label = '{0}. {1}' -f ($i + 1), $choice
            if ($Default -and $choice.Equals($Default, [System.StringComparison]::OrdinalIgnoreCase)) {
                $label = '{0} [default]' -f $label
            }

            Write-Host $label
        }

        $defaultIndex = ''
        if ($Default) {
            for ($i = 0; $i -lt $normalizedChoices.Count; $i++) {
                if ($normalizedChoices[$i].Equals($Default, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $defaultIndex = [string]($i + 1)
                    break
                }
            }
        }

        $value = Read-OptionalValue -Prompt 'Select option number' -Default $defaultIndex

        $selectedIndex = 0
        if ([int]::TryParse($value, [ref]$selectedIndex)) {
            if ($selectedIndex -ge 1 -and $selectedIndex -le $normalizedChoices.Count) {
                return $normalizedChoices[$selectedIndex - 1]
            }
        }

        foreach ($choice in $normalizedChoices) {
            if ($value.Equals($choice, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $choice
            }
        }

        Write-Warning ('Enter a number between 1 and {0}.' -f $normalizedChoices.Count)
    }
}

function Read-YesNo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [bool]$Default = $false
    )

    while ($true) {
        Write-Host $Prompt
        Write-Host ('1. Yes{0}' -f ($(if ($Default) { ' [default]' } else { '' })))
        Write-Host ('2. No{0}' -f ($(if (-not $Default) { ' [default]' } else { '' })))
        $defaultLabel = if ($Default) { '1' } else { '2' }
        $value = Read-OptionalValue -Prompt 'Select option number' -Default $defaultLabel

        switch -Regex ($value.ToLowerInvariant()) {
            '^1$' { return $true }
            '^2$' { return $false }
            '^(y|yes)$' { return $true }
            '^(n|no)$' { return $false }
            default { Write-Warning 'Enter 1 or 2.' }
        }
    }
}

function Read-Port {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        [int]$Default = 0
    )

    while ($true) {
        $defaultText = if ($Default -gt 0) { [string]$Default } else { '' }
        $inputValue = Read-RequiredValue -Prompt $Prompt -Default $defaultText
        $port = 0
        if ([int]::TryParse($inputValue, [ref]$port) -and $port -ge 1 -and $port -le 65535) {
            return $port
        }

        Write-Warning 'Enter a valid TCP port between 1 and 65535.'
    }
}

function Get-PlainTextFromSecureString {
    param(
        [Parameter(Mandatory = $true)]
        [Security.SecureString]$SecureString
    )

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

function Test-Ipv4Address {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $parsed = $null
    if (-not [System.Net.IPAddress]::TryParse($Value, [ref]$parsed)) {
        return $false
    }

    return $parsed.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork
}

function Test-HostOrIpv4 {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    if (Test-Ipv4Address -Value $Value) {
        return $true
    }

    if ($Value.Length -gt 253) {
        return $false
    }

    $labelPattern = '(?!-)[A-Za-z0-9-]{1,63}(?<!-)'
    return $Value -match ('^(?:{0})(?:\.(?:{0}))*$' -f $labelPattern)
}

function Test-Uuid {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $guid = [Guid]::Empty
    return [Guid]::TryParse($Value, [ref]$guid)
}

function ConvertTo-BoolLike {
    param(
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    switch -Regex ($Value.Trim().ToLowerInvariant()) {
        '^(1|true|yes|y|on)$' { return $true }
        '^(0|false|no|n|off)$' { return $false }
        default { return $false }
    }
}

function Get-FirstNonEmptyValue {
    param(
        [string[]]$Values
    )

    foreach ($value in $Values) {
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value.Trim()
        }
    }

    return ''
}

function ConvertFrom-UriQuery {
    param(
        [string]$Query
    )

    $result = @{}
    if ([string]::IsNullOrWhiteSpace($Query)) {
        return $result
    }

    $trimmed = $Query
    if ($trimmed.StartsWith('?')) {
        $trimmed = $trimmed.Substring(1)
    }

    foreach ($pair in ($trimmed -split '&')) {
        if ([string]::IsNullOrWhiteSpace($pair)) {
            continue
        }

        $parts = $pair -split '=', 2
        $key = [Uri]::UnescapeDataString(($parts[0] -replace '\+', ' '))
        $value = ''
        if ($parts.Count -gt 1) {
            $value = [Uri]::UnescapeDataString(($parts[1] -replace '\+', ' '))
        }

        $result[$key] = $value
    }

    return $result
}

function Get-IpCidr {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IpAddress
    )

    return '{0}/32' -f $IpAddress
}

function ConvertFrom-VlessUri {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UriString
    )

    $uri = [Uri]$UriString
    if (-not $uri.Scheme.Equals('vless', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw 'The URI scheme must be vless://'
    }

    if ([string]::IsNullOrWhiteSpace($uri.UserInfo)) {
        throw 'The VLESS URI is missing the UUID.'
    }

    if ([string]::IsNullOrWhiteSpace($uri.Host)) {
        throw 'The VLESS URI is missing the server address.'
    }

    if ($uri.Port -lt 1 -or $uri.Port -gt 65535) {
        throw 'The VLESS URI is missing a valid port.'
    }

    $query = ConvertFrom-UriQuery -Query $uri.Query
    $security = Get-FirstNonEmptyValue -Values @($query['security'], 'none')
    $transport = Get-FirstNonEmptyValue -Values @($query['type'], 'none')
    $path = ''
    if ($query['path']) {
        $path = [Uri]::UnescapeDataString($query['path'])
    }

    $serverName = Get-FirstNonEmptyValue -Values @($query['sni'], $query['serverName'])
    if (-not $serverName -and $security -ne 'none' -and -not (Test-Ipv4Address -Value $uri.Host)) {
        $serverName = $uri.Host
    }

    return @{
        Server               = $uri.Host
        Port                 = $uri.Port
        Uuid                 = $uri.UserInfo
        Flow                 = Get-FirstNonEmptyValue -Values @($query['flow'])
        Security             = $security.ToLowerInvariant()
        Transport            = $transport.ToLowerInvariant()
        ServerName           = $serverName
        Insecure             = (ConvertTo-BoolLike -Value (Get-FirstNonEmptyValue -Values @($query['insecure'], $query['allowInsecure'])))
        UtlsFingerprint      = Get-FirstNonEmptyValue -Values @($query['fp'], $query['fingerprint'])
        RealityPublicKey     = Get-FirstNonEmptyValue -Values @($query['pbk'])
        RealityShortId       = Get-FirstNonEmptyValue -Values @($query['sid'])
        TransportHost        = Get-FirstNonEmptyValue -Values @($query['host'])
        TransportPath        = $path
        TransportServiceName = Get-FirstNonEmptyValue -Values @($query['serviceName'], $query['service_name'])
    }
}

function Ensure-PoshSsh {
    if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
        Write-Host 'Posh-SSH not found. Installing for the current user...'
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
        if (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue) {
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        }

        Install-Module -Name Posh-SSH -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck
    }

    Import-Module Posh-SSH -ErrorAction Stop
}

function Show-RemoteResult {
    param(
        [Parameter(Mandatory = $true)]
        $Result
    )

    if ($Result.Output) {
        $Result.Output | ForEach-Object { Write-Host $_ }
    }

    if ($Result.Error) {
        $Result.Error | ForEach-Object { Write-Warning $_ }
    }
}

function ConvertTo-JsonString {
    param(
        [Parameter(Mandatory = $true)]
        $Value
    )

    return ($Value | ConvertTo-Json -Depth 30)
}

function Invoke-RemoteRootScript {
    param(
        [Parameter(Mandatory = $true)]
        $Session,
        [Parameter(Mandatory = $true)]
        [string]$SudoPassword,
        [Parameter(Mandatory = $true)]
        [string]$ScriptContent
    )

    $scriptBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($ScriptContent))
    $passwordBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($SudoPassword))
    $remoteCommand = @"
set -euo pipefail
umask 077
cat <<'EOF_SCRIPT' | base64 -d > /tmp/codex-singbox-setup.sh
$scriptBase64
EOF_SCRIPT
chmod 700 /tmp/codex-singbox-setup.sh
cat <<'EOF_PASS' | base64 -d | sudo -S -p '' bash /tmp/codex-singbox-setup.sh
$passwordBase64
EOF_PASS
status=`$?
rm -f /tmp/codex-singbox-setup.sh
exit `$status
"@

    return Invoke-SSHCommand -SSHSession $Session -Command $remoteCommand -TimeOut 600
}

function New-BaseConfig {
    return @{
        log      = @{
            level     = 'info'
            timestamp = $true
        }
        dns      = @{
            servers  = @(
                @{
                    type = 'local'
                    tag  = 'local'
                },
                @{
                    type        = 'tls'
                    tag         = 'dns-remote'
                    server      = '1.1.1.1'
                    server_port = 853
                    tls         = @{
                        enabled     = $true
                        server_name = 'cloudflare-dns.com'
                    }
                    detour      = 'proxy'
                }
            )
            strategy = 'prefer_ipv4'
            final    = 'dns-remote'
        }
        inbounds = @(
            @{
                type           = 'tun'
                tag            = 'tun-in'
                interface_name = 'tun0'
                address        = @(
                    '172.19.0.1/30',
                    'fdfe:dcba:9876::1/126'
                )
                auto_route     = $true
                auto_redirect  = $true
            }
        )
    }
}

function New-DirectBypassCidrs {
    param(
        [string[]]$AdditionalCidrs = @()
    )

    $cidrs = @(
        '127.0.0.0/8',
        '::1/128',
        '169.254.0.0/16',
        'fe80::/10',
        '224.0.0.0/4',
        'ff00::/8'
    )

    if ($AdditionalCidrs) {
        $cidrs += $AdditionalCidrs
    }

    return @($cidrs | Select-Object -Unique)
}

function New-RouteConfig {
    param(
        [string[]]$AdditionalCidrs = @()
    )

    return @{
        auto_detect_interface   = $true
        default_domain_resolver = @{
            server   = 'local'
            strategy = 'prefer_ipv4'
        }
        final                   = 'proxy'
        rules                   = @(
            @{
                action = 'sniff'
            },
            @{
                protocol = 'dns'
                action   = 'hijack-dns'
            },
            @{
                ip_cidr  = New-DirectBypassCidrs -AdditionalCidrs $AdditionalCidrs
                action   = 'route'
                outbound = 'direct'
            },
            @{
                ip_is_private = $true
                action        = 'route'
                outbound      = 'direct'
            }
        )
    }
}

function New-SocksOutbound {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    $outbound = @{
        type        = 'socks'
        tag         = 'proxy'
        server      = $Server
        server_port = $Port
        version     = '5'
    }

    if (-not (Test-Ipv4Address -Value $Server)) {
        $outbound.domain_resolver = @{
            server   = 'local'
            strategy = 'prefer_ipv4'
        }
    }

    return $outbound
}

function New-VlessOutbound {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Spec
    )

    $outbound = @{
        type        = 'vless'
        tag         = 'proxy'
        server      = $Spec.Server
        server_port = $Spec.Port
        uuid        = $Spec.Uuid
    }

    if ($Spec.Flow) {
        $outbound.flow = $Spec.Flow
    }

    if (-not (Test-Ipv4Address -Value $Spec.Server)) {
        $outbound.domain_resolver = @{
            server   = 'local'
            strategy = 'prefer_ipv4'
        }
    }

    if ($Spec.Security -ne 'none') {
        $tls = @{
            enabled     = $true
            server_name = $Spec.ServerName
            insecure    = $Spec.Insecure
        }

        if ($Spec.UtlsFingerprint) {
            $tls.utls = @{
                enabled     = $true
                fingerprint = $Spec.UtlsFingerprint
            }
        }

        if ($Spec.Security -eq 'reality') {
            $reality = @{
                enabled    = $true
                public_key = $Spec.RealityPublicKey
            }

            if ($Spec.RealityShortId) {
                $reality.short_id = $Spec.RealityShortId
            }

            $tls.reality = $reality
        }

        $outbound.tls = $tls
    }

    switch ($Spec.Transport) {
        'ws' {
            $transport = @{
                type = 'ws'
            }

            if ($Spec.TransportPath) {
                $transport.path = $Spec.TransportPath
            }

            if ($Spec.TransportHost) {
                $transport.headers = @{
                    Host = $Spec.TransportHost
                }
            }

            $outbound.transport = $transport
        }
        'grpc' {
            $transport = @{
                type = 'grpc'
            }

            if ($Spec.TransportServiceName) {
                $transport.service_name = $Spec.TransportServiceName
            }

            $outbound.transport = $transport
        }
        'httpupgrade' {
            $transport = @{
                type = 'httpupgrade'
            }

            if ($Spec.TransportHost) {
                $transport.host = $Spec.TransportHost
            }

            if ($Spec.TransportPath) {
                $transport.path = $Spec.TransportPath
            }

            $outbound.transport = $transport
        }
    }

    return $outbound
}

function New-SingBoxConfig {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('SOCKS5', 'VLESS')]
        [string]$Mode,
        [Parameter(Mandatory = $true)]
        [hashtable]$ProxySpec
    )

    $config = New-BaseConfig
    $additionalCidrs = @()

    if ($Mode -eq 'SOCKS5') {
        $config.outbounds = @(
            (New-SocksOutbound -Server $ProxySpec.Server -Port $ProxySpec.Port),
            @{
                type = 'direct'
                tag  = 'direct'
            },
            @{
                type = 'block'
                tag  = 'block'
            }
        )

        if (Test-Ipv4Address -Value $ProxySpec.Server) {
            $additionalCidrs += Get-IpCidr -IpAddress $ProxySpec.Server
        }
    }
    else {
        $config.outbounds = @(
            (New-VlessOutbound -Spec $ProxySpec),
            @{
                type = 'direct'
                tag  = 'direct'
            },
            @{
                type = 'block'
                tag  = 'block'
            }
        )
    }

    $config.route = New-RouteConfig -AdditionalCidrs $additionalCidrs
    return $config
}

function New-RemoteSetupScript {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigJson,
        [string]$BootstrapProxy = ''
    )

    $configBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($ConfigJson))
    $bootstrapBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($BootstrapProxy))

    $script = @'
#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP_PROXY="$(printf '%s' '__BOOTSTRAP_BASE64__' | base64 -d)"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required on the remote host." >&2
  exit 1
fi

if ! command -v nft >/dev/null 2>&1; then
  echo "nft was not found. Install nftables on the remote host first." >&2
  exit 1
fi

if [ -n "$BOOTSTRAP_PROXY" ]; then
  export ALL_PROXY="$BOOTSTRAP_PROXY"
  export all_proxy="$BOOTSTRAP_PROXY"
  export HTTPS_PROXY="$BOOTSTRAP_PROXY"
  export https_proxy="$BOOTSTRAP_PROXY"
  export HTTP_PROXY="$BOOTSTRAP_PROXY"
  export http_proxy="$BOOTSTRAP_PROXY"
fi

curl -fsSL https://sing-box.app/install.sh | sh

install -d -m 0755 /etc/sing-box
if [ -f /etc/sing-box/config.json ]; then
  cp /etc/sing-box/config.json "/etc/sing-box/config.json.bak.$(date +%Y%m%d%H%M%S)"
fi

cat <<'EOF_CONFIG' | base64 -d > /etc/sing-box/config.json
__CONFIG_BASE64__
EOF_CONFIG

sing-box check -c /etc/sing-box/config.json
systemctl daemon-reload
systemctl enable sing-box
systemctl restart sing-box
sleep 3
systemctl is-enabled sing-box >/dev/null
systemctl is-active sing-box >/dev/null
'@

    return $script.Replace('__BOOTSTRAP_BASE64__', $bootstrapBase64).Replace('__CONFIG_BASE64__', $configBase64)
}

function New-SocksProbeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    return @"
set -euo pipefail
echo '=== SERVER ==='
whoami
uname -a
echo
echo '=== SOCKS5 TCP ==='
(timeout 5 bash -lc 'cat < /dev/null > /dev/tcp/$Server/$Port' && echo OK) || { echo FAIL; exit 1; }
echo
echo '=== SOCKS5 EGRESS ==='
curl -4 -s --max-time 20 --socks5-hostname $Server`:$Port https://api.ipify.org || true
echo
"@
}

function New-VlessProbeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    return @"
set -euo pipefail
echo '=== SERVER ==='
whoami
uname -a
echo
echo '=== VLESS TCP ==='
(timeout 5 bash -lc 'cat < /dev/null > /dev/tcp/$Server/$Port' && echo OK) || { echo FAIL; exit 1; }
echo
echo '=== DNS RESOLUTION ==='
getent ahostsv4 $Server | head -n 3 || true
echo
"@
}

function New-SocksVerifyCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    return @"
set -euo pipefail
echo '=== ENABLED ==='
systemctl is-enabled sing-box
echo
echo '=== ACTIVE ==='
systemctl is-active sing-box
echo
echo '=== EGRESS IP ==='
curl -4 -s --max-time 20 https://api.ipify.org || true
echo
echo '=== SOCKS SERVER DIRECT ==='
(timeout 5 bash -lc 'cat < /dev/null > /dev/tcp/$Server/$Port' && echo OK) || { echo FAIL; exit 1; }
echo
echo '=== CONFIG PATH ==='
echo /etc/sing-box/config.json
"@
}

function New-VlessVerifyCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    return @"
set -euo pipefail
echo '=== ENABLED ==='
systemctl is-enabled sing-box
echo
echo '=== ACTIVE ==='
systemctl is-active sing-box
echo
echo '=== EGRESS IP ==='
curl -4 -s --max-time 20 https://api.ipify.org || true
echo
echo '=== UPSTREAM TCP ==='
(timeout 5 bash -lc 'cat < /dev/null > /dev/tcp/$Server/$Port' && echo OK) || { echo FAIL; exit 1; }
echo
echo '=== CONFIG PATH ==='
echo /etc/sing-box/config.json
"@
}

Ensure-PoshSsh

$serverIp = Read-RequiredValue -Prompt 'Ubuntu server IPv4'
while (-not (Test-Ipv4Address -Value $serverIp)) {
    Write-Warning 'Enter a valid IPv4 server address.'
    $serverIp = Read-RequiredValue -Prompt 'Ubuntu server IPv4'
}

$sshUser = Read-RequiredValue -Prompt 'SSH username'
$sshPasswordSecure = Read-Host 'SSH password (also used for sudo)' -AsSecureString
$sshPasswordPlain = Get-PlainTextFromSecureString -SecureString $sshPasswordSecure

$mode = Read-ChoiceValue -Prompt 'Proxy mode' -Choices @('SOCKS5', 'VLESS') -Default 'SOCKS5'
$proxySpec = @{}
$bootstrapProxy = ''
$probeCommand = ''
$verifyCommand = ''

if ($mode -eq 'SOCKS5') {
    $socksServer = Read-RequiredValue -Prompt 'SOCKS5 server'
    while (-not (Test-HostOrIpv4 -Value $socksServer)) {
        Write-Warning 'Enter a valid SOCKS5 hostname or IPv4 address.'
        $socksServer = Read-RequiredValue -Prompt 'SOCKS5 server'
    }

    $socksPort = Read-Port -Prompt 'SOCKS5 port' -Default 10808
    $proxySpec = @{
        Server = $socksServer
        Port   = $socksPort
    }
    $bootstrapProxy = 'socks5h://{0}:{1}' -f $socksServer, $socksPort
    $probeCommand = New-SocksProbeCommand -Server $socksServer -Port $socksPort
    $verifyCommand = New-SocksVerifyCommand -Server $socksServer -Port $socksPort
}
else {
    Write-Host ''
    Write-Host 'VLESS mode supports direct/tls/reality and transport none/ws/grpc/httpupgrade.'
    $vlessInputMode = Read-ChoiceValue -Prompt 'VLESS input mode' -Choices @('uri', 'manual') -Default 'uri'

    if ($vlessInputMode -eq 'uri') {
        while ($true) {
            try {
                $vlessUri = Read-RequiredValue -Prompt 'VLESS URI'
                $proxySpec = ConvertFrom-VlessUri -UriString $vlessUri
                break
            }
            catch {
                Write-Warning $_.Exception.Message
            }
        }
    }
    else {
        $vlessServer = Read-RequiredValue -Prompt 'VLESS server'
        while (-not (Test-HostOrIpv4 -Value $vlessServer)) {
            Write-Warning 'Enter a valid VLESS hostname or IPv4 address.'
            $vlessServer = Read-RequiredValue -Prompt 'VLESS server'
        }

        $vlessPort = Read-Port -Prompt 'VLESS port'
        $vlessUuid = Read-RequiredValue -Prompt 'VLESS UUID'
        while (-not (Test-Uuid -Value $vlessUuid)) {
            Write-Warning 'Enter a valid UUID.'
            $vlessUuid = Read-RequiredValue -Prompt 'VLESS UUID'
        }

        $vlessFlow = Read-OptionalValue -Prompt 'VLESS flow (blank if none)' -Default ''
        $vlessSecurity = Read-ChoiceValue -Prompt 'VLESS security' -Choices @('none', 'tls', 'reality')
        $vlessTransport = Read-ChoiceValue -Prompt 'VLESS transport' -Choices @('none', 'ws', 'grpc', 'httpupgrade') -Default 'none'

        $proxySpec = @{
            Server               = $vlessServer
            Port                 = $vlessPort
            Uuid                 = $vlessUuid
            Flow                 = $vlessFlow
            Security             = $vlessSecurity
            Transport            = $vlessTransport
            ServerName           = ''
            Insecure             = $false
            UtlsFingerprint      = ''
            RealityPublicKey     = ''
            RealityShortId       = ''
            TransportHost        = ''
            TransportPath        = ''
            TransportServiceName = ''
        }

        if ($vlessSecurity -ne 'none') {
            $proxySpec.ServerName = Read-RequiredValue -Prompt 'TLS server_name / SNI'
            $proxySpec.Insecure = Read-YesNo -Prompt 'Allow insecure TLS verify' -Default $false

            $fingerprintDefault = if ($vlessSecurity -eq 'reality') { 'chrome' } else { '' }
            $proxySpec.UtlsFingerprint = Read-OptionalValue -Prompt 'uTLS fingerprint (blank if none)' -Default $fingerprintDefault

            if ($vlessSecurity -eq 'reality') {
                $proxySpec.RealityPublicKey = Read-RequiredValue -Prompt 'Reality public_key'
                $proxySpec.RealityShortId = Read-OptionalValue -Prompt 'Reality short_id (blank if none)' -Default ''
            }
        }

        switch ($vlessTransport) {
            'ws' {
                $proxySpec.TransportPath = Read-OptionalValue -Prompt 'WebSocket path' -Default '/'
                $proxySpec.TransportHost = Read-OptionalValue -Prompt 'WebSocket Host header (blank if none)' -Default ''
            }
            'grpc' {
                $proxySpec.TransportServiceName = Read-RequiredValue -Prompt 'gRPC service_name'
            }
            'httpupgrade' {
                $proxySpec.TransportPath = Read-OptionalValue -Prompt 'HTTPUpgrade path' -Default '/'
                $proxySpec.TransportHost = Read-OptionalValue -Prompt 'HTTPUpgrade host (blank if none)' -Default ''
            }
        }
    }

    if (-not (Test-HostOrIpv4 -Value $proxySpec.Server)) {
        throw 'The VLESS server must be a hostname or IPv4 address.'
    }

    if (-not (Test-Uuid -Value $proxySpec.Uuid)) {
        throw 'The VLESS UUID is invalid.'
    }

    if ($proxySpec.Security -notin @('none', 'tls', 'reality')) {
        throw 'The VLESS security value must be none, tls, or reality.'
    }

    if ($proxySpec.Transport -notin @('none', 'ws', 'grpc', 'httpupgrade')) {
        throw 'The VLESS transport value must be none, ws, grpc, or httpupgrade.'
    }

    if ($proxySpec.Security -ne 'none' -and [string]::IsNullOrWhiteSpace($proxySpec.ServerName)) {
        throw 'TLS or Reality mode requires server_name / SNI.'
    }

    if ($proxySpec.Security -eq 'reality' -and [string]::IsNullOrWhiteSpace($proxySpec.RealityPublicKey)) {
        throw 'Reality mode requires public_key.'
    }

    if ($proxySpec.Transport -eq 'ws' -and [string]::IsNullOrWhiteSpace($proxySpec.TransportPath)) {
        $proxySpec.TransportPath = '/'
    }

    $probeCommand = New-VlessProbeCommand -Server $proxySpec.Server -Port $proxySpec.Port
    $verifyCommand = New-VlessVerifyCommand -Server $proxySpec.Server -Port $proxySpec.Port

    Write-Host ''
    Write-Host 'Note: VLESS mode does not bootstrap package downloads through the VLESS node.'
    Write-Host 'The remote server must be able to download the sing-box installer directly on the first run.'
}

$config = New-SingBoxConfig -Mode $mode -ProxySpec $proxySpec
$configJson = ConvertTo-JsonString -Value $config
$setupScript = New-RemoteSetupScript -ConfigJson $configJson -BootstrapProxy $bootstrapProxy
$credential = [System.Management.Automation.PSCredential]::new($sshUser, $sshPasswordSecure)
$session = $null

try {
    Write-Host ''
    Write-Host 'Connecting to the remote server...'
    $session = New-SSHSession -ComputerName $serverIp -Credential $credential -AcceptKey -ConnectionTimeout 15
    if ($session -is [System.Array]) {
        $session = $session[0]
    }

    Write-Host 'Running remote reachability checks...'
    $probeResult = Invoke-SSHCommand -SSHSession $session -Command $probeCommand -TimeOut 120
    Show-RemoteResult -Result $probeResult
    if ($probeResult.ExitStatus -ne 0) {
        throw 'The remote server cannot reach the selected upstream proxy.'
    }

    Write-Host ''
    Write-Host 'Installing and configuring sing-box...'
    $setupResult = Invoke-RemoteRootScript -Session $session -SudoPassword $sshPasswordPlain -ScriptContent $setupScript
    Show-RemoteResult -Result $setupResult
    if ($setupResult.ExitStatus -ne 0) {
        throw 'Remote installation/configuration failed.'
    }

    Write-Host ''
    Write-Host 'Verifying service status and routing...'
    $verifyResult = Invoke-SSHCommand -SSHSession $session -Command $verifyCommand -TimeOut 120
    Show-RemoteResult -Result $verifyResult
    if ($verifyResult.ExitStatus -ne 0) {
        throw 'Verification failed after deployment.'
    }

    Write-Host ''
    Write-Host 'Deployment completed successfully.'
}
finally {
    if ($session) {
        Remove-SSHSession -SSHSession $session | Out-Null
    }
}
