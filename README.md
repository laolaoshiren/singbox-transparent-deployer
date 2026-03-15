# sing-box 透明代理部署脚本

面向 Ubuntu 服务器的可复用 PowerShell 部署脚本。

## 支持内容

- `SOCKS5` 全局透明代理
- `VLESS` 单节点全局透明代理
- `vmess://` 分享链接自动解码并生成 sing-box 配置
- 局域网、私网、回环、链路本地、多播地址自动绕过
- 开机自启

## 交互特点

- 启动第一步先选择语言：`中文` 或 `English`
- 代理模式默认选中 `VLESS / VMess`
- 所有菜单都使用数字选择，例如 `1`、`2`

## 本地运行

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1
```

## 在线一键运行

PowerShell：

```powershell
iex (irm 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1')
```

CMD：

```cmd
powershell -ExecutionPolicy Bypass -Command "iex (irm 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1')"
```

## 说明

- 在线入口只使用 GitHub 官方 raw 地址
- sing-box 安装阶段的网络环境处理在远端服务器上完成
- `SOCKS5` 模式会把 SOCKS5 当成安装阶段引导代理
- `VLESS / VMess` 模式支持直接粘贴 `vless://...` 或 `vmess://...`
- 首次安装时会优先尝试 sing-box 官方 APT 源；如果失败，再回退到官方安装脚本
- 远端系统需要是 Ubuntu，并且 SSH 密码可用于 `sudo`
