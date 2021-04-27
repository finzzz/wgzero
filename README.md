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
- Internal IPv6 communication uses ULA (Unique Local Address).
- Will prioritize on using public IPv6 (shared with all clients) and fallback to IPv4 when not available.
- You need to have IPv6 address similar to `2001::a:b:c:d/64`.
<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/nat.jpg" width="500" height="300">

### Full Routing
- Assign unique public IPv6 to each clients.
- I have tested this feature on Linode, [Hetzner, and Vultr (need ndppd)](#Full-IPv6-routing-on-Hetzner-and-Vultr).
- You need to have IPv6 address similar to `2001:a:b:c::/64`.
    - notice the colons, it means that you can assign multiple addresses to clients.
    - **(Recommended)** you can get free IPv6 block from tunnelbroker.net, /64 is enough.
- **Make sure you don't assign those IP addresses to any interfaces.**  
  Except with tunnelbroker default configuration.
<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/fr.jpg" width="500" height="275">

# Installation
```bash
curl -sO https://raw.githubusercontent.com/finzzz/wgzero/master/wgzero
chmod +x wgzero && ./wgzero install
```
<img src="https://raw.githubusercontent.com/finzzz/wgzero/master/static/install.png" width="675" height="500">


# Other Commands
```
wgzero list
wgzero add clientname
wgzero del clientname
wgzero qr clientname
```

# FAQ, troubleshoot, etc.
## Initial steps on debian
```bash
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update && apt upgrade
apt install linux-headers-$(uname -r) wireguard curl qrencode iptables ipcalc jq
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```

## Running alongside Pihole  
Run `pihole restartdns` after setup

## Full IPv6 routing on Hetzner and Vultr
***Install ndppd before proceeding***

### Hetzner
By default, hetzner allocated a block of IPv6, such as `2a2a:fafa:caca:baba::/64`.  
But address `2a2a:fafa:caca:baba::1/64` is attached to the default network.  
So, in order for this to work, we need to split this block into smaller one.  
In this example, I will arbitrarily use `2a2a:fafa:caca:baba:dada::/80`.  

### Vultr
Similar to hetzner, if you enabled IPv6, you can go to `Settings -> IPv6` section.  
The entry should be similar to this,  
| Address                   | Network               | Netmask | Default Gateway        |
| ------------------------- | --------------------- | ------- | ---------------------- |
| 2a2a:fafa:caca:baba::abcd | 2a2a:fafa:caca:baba:: | 64      | (use router discovery) |


### Installation walkthrough
```
Initializing
Config folder .wgzero already exists, do you want to overwrite [y/N]: y
mode of '/etc/wireguard/wg0.conf' changed from 0644 (rw-r--r--) to 0600 (rw-------)
Writing configs
Available interfaces :
ens3
Interface [eth0]: 
Server [1.2.3.4]: 
Port [51820]: 
Subnet [10.10.0.1/24]: 
Enable IPv6 [y/N]: y
IPv6 Prefix [fd00::]: 2a2a:fafa:caca:baba:dada::
IPv6 Subnet [64]: 80
External routing: 
[1] NAT
[2] Full Routing
Selection [1]: 2
Configure ndppd [y/N]: y
Enable IP forward
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.all.accept_ra = 2
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
Generate server keys
Specify private key [none]: 
Generate config file
Enable service
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip -4 address add 10.10.0.1/24 dev wg0
[#] ip -6 address add 2a2a:fafa:caca:baba:dada::2f04/80 dev wg0
[#] ip link set mtu 1420 up dev wg0
[#] /root/.wgzero/postup.sh FR
Done, make sure 51820/UDP is open
```