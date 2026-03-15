# sing-box 透明代理部署脚本

面向 Ubuntu 服务器的可复用 PowerShell 部署脚本。

## 项目文件

- `deploy-singbox-transparent.ps1`：主交互式部署脚本
- `bootstrap.ps1`：在线引导脚本

## 支持模式

- `SOCKS5`
- `VLESS`

## 功能说明

- 交互输入 Ubuntu 服务器 IPv4、SSH 用户名、SSH 密码、代理模式
- `SOCKS5` 模式支持输入 SOCKS5 服务器和端口
- `VLESS` 模式支持直接粘贴 `vless://...` 链接，或手动输入单节点参数
- `VLESS` 模式支持 `none/tls/reality` 和 `none/ws/grpc/httpupgrade`
- 所有菜单均支持数字选择，例如 `1`、`2`、`3`
- 自动通过 SSH 连接远端服务器
- 自动安装或更新 `sing-box`
- 自动写入 `TUN + auto_route + auto_redirect` 透明代理配置
- 自动绕过局域网/私网、回环、链路本地、多播地址
- 自动设置开机自启并完成连通性验证

## 语言

- 默认中文
- 如需英文界面，可在运行脚本时追加 `-Language en-US`

## 本地运行

默认中文：

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1
```

英文界面：

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1 -Language en-US
```

## 在线一键运行

默认中文：

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1';$p=Join-Path $env:TEMP 'deploy-singbox-transparent.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p"
```

英文界面：

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1';$p=Join-Path $env:TEMP 'deploy-singbox-transparent.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -Language en-US"
```

## Bootstrap 引导命令

默认中文：

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1';$p=Join-Path $env:TEMP 'bootstrap.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -ScriptUrl 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1'"
```

英文界面：

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1';$p=Join-Path $env:TEMP 'bootstrap.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -ScriptUrl 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1' -Language en-US"
```

## 前提条件

- 远端系统为 Ubuntu，且具备 `systemd`、`sudo`、`bash`、`curl`、`nft`
- SSH 密码同时可用于 `sudo`
- `SOCKS5` 模式下，远端服务器需要能访问 SOCKS5 上游
- `VLESS` 模式下，首次运行时远端服务器需要能直接下载 `sing-box` 安装脚本

## 说明

- `SOCKS5` 模式会使用 SOCKS5 作为安装阶段的引导代理
- `VLESS` 模式按 sing-box 官方字段生成单节点配置
- 使用 `vless://...` 时，脚本会自动提取常见字段，例如 `security`、`sni`、`fp`、`type`、`host`、`path`、`flow`、`pbk`、`sid`、`serviceName`
- 部署完成后，公网流量将走所选上游代理

<details>
<summary>English</summary>

## Files

- `deploy-singbox-transparent.ps1`: main interactive deploy script
- `bootstrap.ps1`: lightweight online launcher

## Supported modes

- `SOCKS5`
- `VLESS`

## Features

- Prompts for Ubuntu server IPv4, SSH username, SSH password, and proxy mode
- `SOCKS5` mode supports SOCKS5 server and port
- `VLESS` mode supports either a `vless://...` URI or manual single-node input
- `VLESS` mode supports `none/tls/reality` and `none/ws/grpc/httpupgrade`
- All menus use numeric selection such as `1`, `2`, `3`
- Connects to the remote host over SSH
- Installs or updates `sing-box`
- Writes a `TUN + auto_route + auto_redirect` transparent proxy config
- Bypasses LAN/private, loopback, link-local, and multicast ranges
- Enables the service at boot and verifies connectivity

## Language

- Default UI language is Chinese
- Add `-Language en-US` to switch to English

## Local run

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1 -Language en-US
```

## Online one-command

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1';$p=Join-Path $env:TEMP 'deploy-singbox-transparent.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -Language en-US"
```

## Bootstrap command

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1';$p=Join-Path $env:TEMP 'bootstrap.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -ScriptUrl 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1' -Language en-US"
```

</details>
