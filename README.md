# WGZero
Zero overhead wireguard setup. Tested on Debian 10.

# Table of contents
- [Requirements](#requirements)
    - [Packages](#Packages)
    - [IPv6](#ipv6)
        - [NAT](#nat)
        - [Full Routing](#Full-Routing)
- [Installation](#installation)
- [Other Commands](#other-commands)
- [FAQ, troubleshoot, etc.](#faq--troubleshoot--etc)

# Requirements
## Packages
[wireguard](https://www.wireguard.com/install/) curl qrencode iptables ipcalc jq

## IPv6
If you need IPv6, please make sure you can access internet using ipv6 before proceeding.

There are 2 types of connection:
### NAT
- Public IPv6 is being shared, and internal IPv6 uses ULA (Unique Local Address).
- You need to have IPv6 address similar to `2001::a:b:c:d/64`.
<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/nat.jpg" width="500" height="300">

### Full Routing
- Assign public IPv6 to each clients.
- Personally, I got this feature works only on Linode and [Hetzner](#full-routing-ipv6-on-hetzner)(need ndppd).
  - Vultr failed, not sure other about providers.
- You need to have IPv6 address similar to `2001:a:b:c::/64`.
    - notice the colons, it means that you can assign multiple addresses to clients.
- **Make sure you don't assign those IP addresses to any interfaces.**

<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/fr.jpg" width="500" height="275">


# Installation
```bash
curl -sO https://raw.githubusercontent.com/finzzz/wgzero/master/wgzero
chmod +x wgzero && ./wgzero install
```

<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/install.png" width="700" height="500">

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
apt install linux-headers-$(uname -r) wireguard curl qrencode iptables ipcalc jq
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```

- Running alongside Pihole  
Run `pihole restartdns` after setup

- Full routing IPv6 on Hetzner
***Install ndppd before proceeding***
By default, hetzner allocated a block of IPv6, such as `2a2a:fafa:caca:baba::/64`.
But address `2a2a:fafa:caca:baba::1/64` is attached to the default network.
So, in order for this to work, we need to split this block into smaller one.
In this example, I will arbitrarily use `2a2a:fafa:caca:baba:dada::/80`.

1. Create `/etc/ndppd.conf` with the following content
```
proxy eth0 {
    timeout 500
    ttl 16000
    rule 2a2a:fafa:caca:baba:dada::/80 {
        static
    }
}
```
2. Enable and start ndppd
3. On installation, assign this IPv6 prefix
```
...
IPv6 Prefix [fd00::]: 2a2a:fafa:caca:baba:dada::
...
```
4. For now, you need to manually configure server configuration on `/etc/wireguard/wg0.conf` and client config.  
Change `/64` to `/80` and reboot. This will be automated in the upcoming release.
