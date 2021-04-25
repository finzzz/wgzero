# WGZero
Zero overhead wireguard setup. Tested on Debian 10.

# Table of contents
- [Requirements](#requirements)
    - [IPv6](#ipv6)
        - [NAT](#nat)
        - [Full Routing](#Full-Routing)
- [Installation](#installation)
- [Other Commands](#other-commands)
- [FAQ, troubleshoot, etc.](#faq--troubleshoot--etc)

# Requirements
- [wireguard](https://www.wireguard.com/install/)
- curl
- qrencode
- iptables
- ipcalc
- jq

## IPv6
If you need IPv6, please make sure you can access internet using ipv6 before proceeding.

There are 2 types of connection:
### NAT
- public IPv6 is being shared, and internal IPv6 uses ULA (Unique Local Address)
- you need to have IPv6 address similar to `2001::a:b:c:d/64`
![](static/nat.jpg)

### Full Routing
- assign public IPv6 to each clients
- you need to have IPv6 address similar to `2001:a:b:c::/64`
    - notice the colons, it means that you can assign multiple addresses to clients
    - not every providers provide this, some require opening a ticket (linode provides this)
- **make sure you don't assign those IP addresses to any interfaces**

![](static/fr.jpg)


# Installation
```bash
curl -sO https://raw.githubusercontent.com/finzzz/wgzero/master/wgzero

chmod +x wgzero
./wgzero install
```

![](static/install.png)

# Other Commands
```
wgzero list
wgzero add clientname
wgzero del clientname
wgzero qr clientname
```

# FAQ, troubleshoot, etc.
- Initial steps on debian
```bash
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update && apt upgrade
apt install linux-headers-$(uname -r) wireguard qrencode ipcalc curl iptables jq
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```

- Running alongside Pihole  
Run `pihole restartdns` after setup