# WGZero
CLI based wireguard server manager. Tested on Debian Bullseye.

## Features
- Plain IPv4 installation with multiple interfaces
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
- Will prioritize on using public IPv6 (shared with all clients) and fallback to IPv4 when not available.
- You need to have IPv6 address similar to `2001::a:b:c:d/64`.
<details>
  <summary>see image</summary>
  <img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/nat.jpg" width="500" height="300">
</details>

#### Full Routing
- Assign unique public IPv6 to each clients.
- I have tested this feature on Linode. Hetzner, and Vultr (need ndppd).
- You need to have IPv6 address similar to `2001:a:b:c::/64`.
    - notice the colons, it means that you can assign multiple addresses to clients.
    - **(Recommended)** you can get free IPv6 block from tunnelbroker.net, /64 is enough.
- **Make sure you don't assign those IP addresses to any interfaces.**  
  Except with tunnelbroker default configuration.
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
- [Full Routing](docs/fr.md)
- [Full Routing with Tunnerbroker](docs/tunnelbroker.md)

## Backup and restore
Backup is simple, just save /etc/wireguard/<interface name>.conf. All of the data including clients are stored in that file.
To restore, simply run `wgzero import <interface name>.conf` on new host.

### Other Commands
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