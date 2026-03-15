# sing-box transparent proxy deployer

Reusable PowerShell deployer for Ubuntu servers.

Files:

- `deploy-singbox-transparent.ps1`: main interactive deploy script
- `bootstrap.ps1`: lightweight online launcher

Supported modes:

- `SOCKS5`
- `VLESS`

What it does:

- Prompts for the Ubuntu server IPv4 address, SSH username, SSH password, and proxy mode.
- In `SOCKS5` mode, prompts for SOCKS5 server and port.
- In `VLESS` mode, supports either a full `vless://...` URI or manual entry.
- In `VLESS` mode, supports a single VLESS node with `none/tls/reality` and `none/ws/grpc/httpupgrade`.
- Choice prompts use numeric selection (`1`, `2`, `3`...) so you do not need to type the full option text.
- Connects to the server over SSH with `Posh-SSH`.
- Installs or updates `sing-box` using the official installer.
- Writes a `TUN + auto_route + auto_redirect` transparent proxy config.
- Bypasses LAN/private ranges, loopback, link-local, and multicast.
- Enables `sing-box` at boot and verifies the service.

Run locally:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy-singbox-transparent.ps1
```

Online one-command:

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1';$p=Join-Path $env:TEMP 'deploy-singbox-transparent.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p"
```

Bootstrap command:

```powershell
powershell -ExecutionPolicy Bypass -Command "$u='https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/bootstrap.ps1';$p=Join-Path $env:TEMP 'bootstrap.ps1';Invoke-WebRequest -Uri $u -OutFile $p;& powershell -ExecutionPolicy Bypass -File $p -ScriptUrl 'https://raw.githubusercontent.com/laolaoshiren/singbox-transparent-deployer/main/deploy-singbox-transparent.ps1'"
```

Assumptions:

- The remote host is Ubuntu with `systemd`, `sudo`, `bash`, `curl`, and `nft` available.
- The SSH password is also valid for `sudo`.
- In `SOCKS5` mode, the remote host can reach the SOCKS5 upstream.
- In `VLESS` mode, the remote host can download the `sing-box` installer directly on the first run.

Notes:

- `SOCKS5` mode uses the SOCKS proxy as the bootstrap path for installing `sing-box`.
- `VLESS` mode is based on sing-box official outbound fields. If your node requires specific values like `flow=xtls-rprx-vision`, `server_name`, `uTLS fingerprint`, `Reality public_key`, `short_id`, or transport fields, enter them exactly as provided by your node.
- When using a `vless://...` URI, the script extracts common fields such as `security`, `sni`, `fp`, `type`, `host`, `path`, `flow`, `pbk`, `sid`, and `serviceName`.
- Public internet traffic is routed through the selected upstream proxy after deployment.
