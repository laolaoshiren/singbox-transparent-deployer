# sing-box 透明代理部署脚本

面向 Ubuntu 服务器的可复用 PowerShell 部署脚本。

## 支持内容

- `VLESS`
- `VMess` 分享链接导入
- `Trojan`
- `Hysteria2`
- `Shadowsocks`
- `SOCKS5`
- 局域网、私网、回环、链路本地、多播地址自动绕过
- 开机自启

## 交互特点

- 启动第一步先选择语言：`中文` 或 `English`
- 代理模式默认选中 `VLESS / VMess`
- 所有菜单都使用数字选择，例如 `1`、`2`
- `VLESS` 模式支持直接粘贴 `vless://...` 或 `vmess://...`
- `Trojan`、`Hysteria2`、`Shadowsocks`、`SOCKS5` 目前为手动输入节点参数

## 本地运行

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1
```

## 在线一键运行

PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -Command "iex (irm 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1')"
```

CMD：

```cmd
powershell -ExecutionPolicy Bypass -Command "iex (irm 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1')"
```

## 说明

- PowerShell 和 CMD 都统一通过新的 `powershell.exe` 进程启动，避免当前会话环境干扰 SSH 连接
- 在线入口只使用 GitHub 官方 raw 地址
- sing-box 安装阶段的网络环境处理在远端服务器上完成
- 首次安装时会优先尝试 sing-box 官方 APT 源；如果失败，再回退到官方安装脚本
- 再次运行脚本修改节点时，会跳过 sing-box 安装，只更新配置
- 远端系统需要是 Ubuntu，并且 SSH 密码可用于 `sudo`
