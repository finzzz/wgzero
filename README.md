# WGZero
CLI based wireguard server manager. Tested on Debian Bullseye.

## Features
- Plain IPv4 installation
- Multi interfaces support
- IPv6
  - NAT
  - Full routing
- Import & uninstall
- Easy backup

## Requirements
### Packages
[wireguard](https://www.wireguard.com/install/) curl qrencode iptables jq

### IPv6
If you need IPv6, please make sure you can access internet using ipv6 before proceeding.

There are 2 types of connection:
#### NAT
- Internal IPv6 communication uses ULA (Unique Local Address).
- Prioritize on using public IPv6 (shared with all clients) and fallback to IPv4 when not available.
<details>
  <summary>see image</summary>
  <img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/nat.jpg" width="500" height="300">
</details>

#### Full Routing
- Assign unique public IPv6 to each clients.
- You need to have an IPv6 address and a block of /64 IPv6 addresses.
  - IPv6 address should be assigned to main interface and /64 is reserved for wireguard
  - If you only get /64 from VPS provider, you need to split it into smaller blocks and install ndppd (see [example](docs/fr.md))
  - If you don't have it, you can get free IPv6 from [Tunnelbroker](https://tunnelbroker.net/) (see [example](docs/tunnelbroker.md))
<details>
  <summary>see image</summary>
  <img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/fr.jpg" width="500" height="275">
</details>

## Installation
```bash
curl -o /usr/local/bin/wgzero https://raw.githubusercontent.com/finzzz/wgzero/master/wgzero
chmod +x /usr/local/bin/wgzero
wgzero install
```

### Example Installation
- [Plain IPv4](docs/v4.md)
- [NAT](docs/nat.md)
- Full Routing
  - [only has /64 block](docs/fr.md)
  - [Tunnerbroker](docs/tunnelbroker.md)

## Backup and restore
Backup is simple, just save `/etc/wireguard/<interface name>.conf`. All of the data including clients are stored in that file.
To restore, simply run `wgzero import <interface name>.conf` on new host.

## Other Commands
```
wgzero install
wgzero uninstall <wg_interface>
wgzero import wg0.conf

# default wg0
wgzero list <wg_interface>
wgzero show clientname <wg_interface> 
wgzero qr clientname <wg_interface> 
wgzero enable clientname <wg_interface>
wgzero disable clientname <wg_interface> 
wgzero del clientname <wg_interface>
```

## [FAQ and Troubleshooting](docs/faq.md)