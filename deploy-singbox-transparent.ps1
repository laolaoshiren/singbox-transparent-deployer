[CmdletBinding()]
param(
    [string]$Language = 'zh-CN'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-Language {
    param(
        [string]$Value
    )

    $normalized = ''
    if ($null -ne $Value) {
        $normalized = $Value.Trim().ToLowerInvariant()
    }

    switch ($normalized) {
        'en' { return 'en-US' }
        'en-us' { return 'en-US' }
        'zh' { return 'zh-CN' }
        'zh-cn' { return 'zh-CN' }
        default { return 'zh-CN' }
    }
}

$script:Language = Resolve-Language -Value $Language
$script:Messages = @{
    'zh-CN' = @{
        DefaultTag               = '默认'
        SelectOptionNumber       = '请输入选项编号'
        EnterNumberBetween       = '请输入 1 到 {0} 之间的数字。'
        YesLabel                 = '是'
        NoLabel                  = '否'
        EnterOneOrTwo            = '请输入 1 或 2。'
        ValidPortRange           = '请输入 1 到 65535 之间的有效端口。'
        UriSchemeInvalid         = 'URI 协议必须是 vless://'
        UriMissingUuid           = 'VLESS URI 缺少 UUID。'
        UriMissingServer         = 'VLESS URI 缺少服务器地址。'
        UriMissingPort           = 'VLESS URI 缺少有效端口。'
        InstallPoshSsh           = '未检测到 Posh-SSH，正在为当前用户安装...'
        ServerIpPrompt           = 'Ubuntu 服务器 IPv4'
        InvalidServerIp          = '请输入有效的 IPv4 服务器地址。'
        SshUsernamePrompt        = 'SSH 用户名'
        SshPasswordPrompt        = 'SSH 密码（同时作为 sudo 密码）'
        ProxyModePrompt          = '代理模式'
        SocksServerPrompt        = 'SOCKS5 服务器'
        InvalidSocksServer       = '请输入有效的 SOCKS5 主机名或 IPv4 地址。'
        SocksPortPrompt          = 'SOCKS5 端口'
        VlessModeIntro           = 'VLESS 模式支持 direct/tls/reality，以及 none/ws/grpc/httpupgrade 传输。'
        VlessInputModePrompt     = 'VLESS 输入方式'
        VlessInputUriLabel       = 'URI 链接'
        VlessInputManualLabel    = '手动输入'
        VlessUriPrompt           = 'VLESS URI'
        VlessServerPrompt        = 'VLESS 服务器'
        InvalidVlessServer       = '请输入有效的 VLESS 主机名或 IPv4 地址。'
        VlessPortPrompt          = 'VLESS 端口'
        VlessUuidPrompt          = 'VLESS UUID'
        InvalidUuid              = '请输入有效的 UUID。'
        VlessFlowPrompt          = 'VLESS flow（留空表示无）'
        VlessSecurityPrompt      = 'VLESS 安全类型'
        VlessTransportPrompt     = 'VLESS 传输类型'
        TlsServerNamePrompt      = 'TLS server_name / SNI'
        AllowInsecurePrompt      = '是否允许跳过 TLS 证书校验'
        UtlsFingerprintPrompt    = 'uTLS 指纹（留空表示不设置）'
        RealityPublicKeyPrompt   = 'Reality public_key'
        RealityShortIdPrompt     = 'Reality short_id（留空表示无）'
        WsPathPrompt             = 'WebSocket 路径'
        WsHostPrompt             = 'WebSocket Host 头（留空表示不设置）'
        GrpcServicePrompt        = 'gRPC service_name'
        HttpUpgradePathPrompt    = 'HTTPUpgrade 路径'
        HttpUpgradeHostPrompt    = 'HTTPUpgrade host（留空表示不设置）'
        VlessServerInvalid       = 'VLESS 服务器必须是主机名或 IPv4 地址。'
        VlessUuidInvalid         = 'VLESS UUID 无效。'
        VlessSecurityInvalid     = 'VLESS 安全类型必须是 none、tls 或 reality。'
        VlessTransportInvalid    = 'VLESS 传输类型必须是 none、ws、grpc 或 httpupgrade。'
        TlsServerNameRequired    = 'TLS 或 Reality 模式必须提供 server_name / SNI。'
        RealityPublicKeyRequired = 'Reality 模式必须提供 public_key。'
        VlessNoBootstrap1        = '注意：VLESS 模式不会通过 VLESS 节点为安装过程引导下载。'
        VlessNoBootstrap2        = '首次运行时，远端服务器必须能直接下载 sing-box 安装脚本。'
        ConnectingRemote         = '正在连接远端服务器...'
        RunningChecks            = '正在执行远端连通性检查...'
        UpstreamUnreachable      = '远端服务器无法连通所选上游代理。'
        InstallingConfiguring    = '正在安装并配置 sing-box...'
        RemoteInstallFailed      = '远端安装或配置失败。'
        VerifyingStatus          = '正在验证服务状态和路由结果...'
        VerificationFailed       = '部署后的验证失败。'
        DeploymentSuccess        = '部署完成。'
    }
    'en-US' = @{
        DefaultTag               = 'default'
        SelectOptionNumber       = 'Select option number'
        EnterNumberBetween       = 'Enter a number between 1 and {0}.'
        YesLabel                 = 'Yes'
        NoLabel                  = 'No'
        EnterOneOrTwo            = 'Enter 1 or 2.'
        ValidPortRange           = 'Enter a valid port between 1 and 65535.'
        UriSchemeInvalid         = 'The URI scheme must be vless://'
        UriMissingUuid           = 'The VLESS URI is missing the UUID.'
        UriMissingServer         = 'The VLESS URI is missing the server address.'
        UriMissingPort           = 'The VLESS URI is missing a valid port.'
        InstallPoshSsh           = 'Posh-SSH not found. Installing for the current user...'
        ServerIpPrompt           = 'Ubuntu server IPv4'
        InvalidServerIp          = 'Enter a valid IPv4 server address.'
        SshUsernamePrompt        = 'SSH username'
        SshPasswordPrompt        = 'SSH password (also used for sudo)'
        ProxyModePrompt          = 'Proxy mode'
        SocksServerPrompt        = 'SOCKS5 server'
        InvalidSocksServer       = 'Enter a valid SOCKS5 hostname or IPv4 address.'
        SocksPortPrompt          = 'SOCKS5 port'
        VlessModeIntro           = 'VLESS mode supports direct/tls/reality and transport none/ws/grpc/httpupgrade.'
        VlessInputModePrompt     = 'VLESS input mode'
        VlessInputUriLabel       = 'URI'
        VlessInputManualLabel    = 'manual'
        VlessUriPrompt           = 'VLESS URI'
        VlessServerPrompt        = 'VLESS server'
        InvalidVlessServer       = 'Enter a valid VLESS hostname or IPv4 address.'
        VlessPortPrompt          = 'VLESS port'
        VlessUuidPrompt          = 'VLESS UUID'
        InvalidUuid              = 'Enter a valid UUID.'
        VlessFlowPrompt          = 'VLESS flow (blank if none)'
        VlessSecurityPrompt      = 'VLESS security'
        VlessTransportPrompt     = 'VLESS transport'
        TlsServerNamePrompt      = 'TLS server_name / SNI'
        AllowInsecurePrompt      = 'Allow insecure TLS verify'
        UtlsFingerprintPrompt    = 'uTLS fingerprint (blank if none)'
        RealityPublicKeyPrompt   = 'Reality public_key'
        RealityShortIdPrompt     = 'Reality short_id (blank if none)'
        WsPathPrompt             = 'WebSocket path'
        WsHostPrompt             = 'WebSocket Host header (blank if none)'
        GrpcServicePrompt        = 'gRPC service_name'
        HttpUpgradePathPrompt    = 'HTTPUpgrade path'
        HttpUpgradeHostPrompt    = 'HTTPUpgrade host (blank if none)'
        VlessServerInvalid       = 'The VLESS server must be a hostname or IPv4 address.'
        VlessUuidInvalid         = 'The VLESS UUID is invalid.'
        VlessSecurityInvalid     = 'The VLESS security value must be none, tls, or reality.'
        VlessTransportInvalid    = 'The VLESS transport value must be none, ws, grpc, or httpupgrade.'
        TlsServerNameRequired    = 'TLS or Reality mode requires server_name / SNI.'
        RealityPublicKeyRequired = 'Reality mode requires public_key.'
        VlessNoBootstrap1        = 'Note: VLESS mode does not bootstrap package downloads through the VLESS node.'
        VlessNoBootstrap2        = 'The remote server must be able to download the sing-box installer directly on the first run.'
        ConnectingRemote         = 'Connecting to the remote server...'
        RunningChecks            = 'Running remote reachability checks...'
        UpstreamUnreachable      = 'The remote server cannot reach the selected upstream proxy.'
        InstallingConfiguring    = 'Installing and configuring sing-box...'
        RemoteInstallFailed      = 'Remote installation/configuration failed.'
        VerifyingStatus          = 'Verifying service status and routing...'
        VerificationFailed       = 'Verification failed after deployment.'
        DeploymentSuccess        = 'Deployment completed successfully.'
    }
}

function Get-Text {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key,
        [object[]]$FormatArgs = @()
    )

    $template = $script:Messages[$script:Language][$Key]
    if (-not $template) {
        $template = $script:Messages['en-US'][$Key]
    }

    if ($FormatArgs.Count -gt 0) {
        return [string]::Format($template, $FormatArgs)
    }

    return $template
}

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
        [string]$Default = '',
        [string[]]$ChoiceLabels = @()
    )

    $normalizedChoices = $Choices | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $displayChoices = if ($ChoiceLabels.Count -eq $normalizedChoices.Count) { $ChoiceLabels } else { $normalizedChoices }
    while ($true) {
        Write-Host $Prompt
        for ($i = 0; $i -lt $normalizedChoices.Count; $i++) {
            $label = '{0}. {1}' -f ($i + 1), $displayChoices[$i]
            if ($Default -and $normalizedChoices[$i].Equals($Default, [System.StringComparison]::OrdinalIgnoreCase)) {
                $label = '{0} [{1}]' -f $label, (Get-Text 'DefaultTag')
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

        $value = Read-OptionalValue -Prompt (Get-Text 'SelectOptionNumber') -Default $defaultIndex

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

        for ($i = 0; $i -lt $displayChoices.Count; $i++) {
            if ($value.Equals($displayChoices[$i], [System.StringComparison]::OrdinalIgnoreCase)) {
                return $normalizedChoices[$i]
            }
        }

        Write-Warning (Get-Text 'EnterNumberBetween' $normalizedChoices.Count)
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
        Write-Host ('1. {0}{1}' -f (Get-Text 'YesLabel'), ($(if ($Default) { ' [{0}]' -f (Get-Text 'DefaultTag') } else { '' })))
        Write-Host ('2. {0}{1}' -f (Get-Text 'NoLabel'), ($(if (-not $Default) { ' [{0}]' -f (Get-Text 'DefaultTag') } else { '' })))
        $defaultLabel = if ($Default) { '1' } else { '2' }
        $value = Read-OptionalValue -Prompt (Get-Text 'SelectOptionNumber') -Default $defaultLabel

        switch -Regex ($value.ToLowerInvariant()) {
            '^1$' { return $true }
            '^2$' { return $false }
            '^(y|yes|是)$' { return $true }
            '^(n|no|否)$' { return $false }
            default { Write-Warning (Get-Text 'EnterOneOrTwo') }
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

        Write-Warning (Get-Text 'ValidPortRange')
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
        '^(1|true|yes|y|on|是)$' { return $true }
        '^(0|false|no|n|off|否)$' { return $false }
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
        throw (Get-Text 'UriSchemeInvalid')
    }

    if ([string]::IsNullOrWhiteSpace($uri.UserInfo)) {
        throw (Get-Text 'UriMissingUuid')
    }

    if ([string]::IsNullOrWhiteSpace($uri.Host)) {
        throw (Get-Text 'UriMissingServer')
    }

    if ($uri.Port -lt 1 -or $uri.Port -gt 65535) {
        throw (Get-Text 'UriMissingPort')
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
        Write-Host (Get-Text 'InstallPoshSsh')
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

$serverIp = Read-RequiredValue -Prompt (Get-Text 'ServerIpPrompt')
while (-not (Test-Ipv4Address -Value $serverIp)) {
    Write-Warning (Get-Text 'InvalidServerIp')
    $serverIp = Read-RequiredValue -Prompt (Get-Text 'ServerIpPrompt')
}

$sshUser = Read-RequiredValue -Prompt (Get-Text 'SshUsernamePrompt')
$sshPasswordSecure = Read-Host (Get-Text 'SshPasswordPrompt') -AsSecureString
$sshPasswordPlain = Get-PlainTextFromSecureString -SecureString $sshPasswordSecure

$mode = Read-ChoiceValue -Prompt (Get-Text 'ProxyModePrompt') -Choices @('SOCKS5', 'VLESS') -Default 'SOCKS5'
$proxySpec = @{}
$bootstrapProxy = ''
$probeCommand = ''
$verifyCommand = ''

if ($mode -eq 'SOCKS5') {
    $socksServer = Read-RequiredValue -Prompt (Get-Text 'SocksServerPrompt')
    while (-not (Test-HostOrIpv4 -Value $socksServer)) {
        Write-Warning (Get-Text 'InvalidSocksServer')
        $socksServer = Read-RequiredValue -Prompt (Get-Text 'SocksServerPrompt')
    }

    $socksPort = Read-Port -Prompt (Get-Text 'SocksPortPrompt') -Default 10808
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
    Write-Host (Get-Text 'VlessModeIntro')
    $vlessInputMode = Read-ChoiceValue -Prompt (Get-Text 'VlessInputModePrompt') -Choices @('uri', 'manual') -ChoiceLabels @((Get-Text 'VlessInputUriLabel'), (Get-Text 'VlessInputManualLabel')) -Default 'uri'

    if ($vlessInputMode -eq 'uri') {
        while ($true) {
            try {
                $vlessUri = Read-RequiredValue -Prompt (Get-Text 'VlessUriPrompt')
                $proxySpec = ConvertFrom-VlessUri -UriString $vlessUri
                break
            }
            catch {
                Write-Warning $_.Exception.Message
            }
        }
    }
    else {
        $vlessServer = Read-RequiredValue -Prompt (Get-Text 'VlessServerPrompt')
        while (-not (Test-HostOrIpv4 -Value $vlessServer)) {
            Write-Warning (Get-Text 'InvalidVlessServer')
            $vlessServer = Read-RequiredValue -Prompt (Get-Text 'VlessServerPrompt')
        }

        $vlessPort = Read-Port -Prompt (Get-Text 'VlessPortPrompt')
        $vlessUuid = Read-RequiredValue -Prompt (Get-Text 'VlessUuidPrompt')
        while (-not (Test-Uuid -Value $vlessUuid)) {
            Write-Warning (Get-Text 'InvalidUuid')
            $vlessUuid = Read-RequiredValue -Prompt (Get-Text 'VlessUuidPrompt')
        }

        $vlessFlow = Read-OptionalValue -Prompt (Get-Text 'VlessFlowPrompt') -Default ''
        $vlessSecurity = Read-ChoiceValue -Prompt (Get-Text 'VlessSecurityPrompt') -Choices @('none', 'tls', 'reality')
        $vlessTransport = Read-ChoiceValue -Prompt (Get-Text 'VlessTransportPrompt') -Choices @('none', 'ws', 'grpc', 'httpupgrade') -Default 'none'

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
            $proxySpec.ServerName = Read-RequiredValue -Prompt (Get-Text 'TlsServerNamePrompt')
            $proxySpec.Insecure = Read-YesNo -Prompt (Get-Text 'AllowInsecurePrompt') -Default $false

            $fingerprintDefault = if ($vlessSecurity -eq 'reality') { 'chrome' } else { '' }
            $proxySpec.UtlsFingerprint = Read-OptionalValue -Prompt (Get-Text 'UtlsFingerprintPrompt') -Default $fingerprintDefault

            if ($vlessSecurity -eq 'reality') {
                $proxySpec.RealityPublicKey = Read-RequiredValue -Prompt (Get-Text 'RealityPublicKeyPrompt')
                $proxySpec.RealityShortId = Read-OptionalValue -Prompt (Get-Text 'RealityShortIdPrompt') -Default ''
            }
        }

        switch ($vlessTransport) {
            'ws' {
                $proxySpec.TransportPath = Read-OptionalValue -Prompt (Get-Text 'WsPathPrompt') -Default '/'
                $proxySpec.TransportHost = Read-OptionalValue -Prompt (Get-Text 'WsHostPrompt') -Default ''
            }
            'grpc' {
                $proxySpec.TransportServiceName = Read-RequiredValue -Prompt (Get-Text 'GrpcServicePrompt')
            }
            'httpupgrade' {
                $proxySpec.TransportPath = Read-OptionalValue -Prompt (Get-Text 'HttpUpgradePathPrompt') -Default '/'
                $proxySpec.TransportHost = Read-OptionalValue -Prompt (Get-Text 'HttpUpgradeHostPrompt') -Default ''
            }
        }
    }

    if (-not (Test-HostOrIpv4 -Value $proxySpec.Server)) {
        throw (Get-Text 'VlessServerInvalid')
    }

    if (-not (Test-Uuid -Value $proxySpec.Uuid)) {
        throw (Get-Text 'VlessUuidInvalid')
    }

    if ($proxySpec.Security -notin @('none', 'tls', 'reality')) {
        throw (Get-Text 'VlessSecurityInvalid')
    }

    if ($proxySpec.Transport -notin @('none', 'ws', 'grpc', 'httpupgrade')) {
        throw (Get-Text 'VlessTransportInvalid')
    }

    if ($proxySpec.Security -ne 'none' -and [string]::IsNullOrWhiteSpace($proxySpec.ServerName)) {
        throw (Get-Text 'TlsServerNameRequired')
    }

    if ($proxySpec.Security -eq 'reality' -and [string]::IsNullOrWhiteSpace($proxySpec.RealityPublicKey)) {
        throw (Get-Text 'RealityPublicKeyRequired')
    }

    if ($proxySpec.Transport -eq 'ws' -and [string]::IsNullOrWhiteSpace($proxySpec.TransportPath)) {
        $proxySpec.TransportPath = '/'
    }

    $probeCommand = New-VlessProbeCommand -Server $proxySpec.Server -Port $proxySpec.Port
    $verifyCommand = New-VlessVerifyCommand -Server $proxySpec.Server -Port $proxySpec.Port

    Write-Host ''
    Write-Host (Get-Text 'VlessNoBootstrap1')
    Write-Host (Get-Text 'VlessNoBootstrap2')
}

$config = New-SingBoxConfig -Mode $mode -ProxySpec $proxySpec
$configJson = ConvertTo-JsonString -Value $config
$setupScript = New-RemoteSetupScript -ConfigJson $configJson -BootstrapProxy $bootstrapProxy
$credential = [System.Management.Automation.PSCredential]::new($sshUser, $sshPasswordSecure)
$session = $null

try {
    Write-Host ''
    Write-Host (Get-Text 'ConnectingRemote')
    $session = New-SSHSession -ComputerName $serverIp -Credential $credential -AcceptKey -ConnectionTimeout 15
    if ($session -is [System.Array]) {
        $session = $session[0]
    }

    Write-Host (Get-Text 'RunningChecks')
    $probeResult = Invoke-SSHCommand -SSHSession $session -Command $probeCommand -TimeOut 120
    Show-RemoteResult -Result $probeResult
    if ($probeResult.ExitStatus -ne 0) {
        throw (Get-Text 'UpstreamUnreachable')
    }

    Write-Host ''
    Write-Host (Get-Text 'InstallingConfiguring')
    $setupResult = Invoke-RemoteRootScript -Session $session -SudoPassword $sshPasswordPlain -ScriptContent $setupScript
    Show-RemoteResult -Result $setupResult
    if ($setupResult.ExitStatus -ne 0) {
        throw (Get-Text 'RemoteInstallFailed')
    }

    Write-Host ''
    Write-Host (Get-Text 'VerifyingStatus')
    $verifyResult = Invoke-SSHCommand -SSHSession $session -Command $verifyCommand -TimeOut 120
    Show-RemoteResult -Result $verifyResult
    if ($verifyResult.ExitStatus -ne 0) {
        throw (Get-Text 'VerificationFailed')
    }

    Write-Host ''
    Write-Host (Get-Text 'DeploymentSuccess')
}
finally {
    if ($session) {
        Remove-SSHSession -SSHSession $session | Out-Null
    }
}
