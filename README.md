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
[wireguard](https://www.wireguard.com/install/) curl qrencode iptables jq

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

## Example
```
root@vultr:~# ./wgzero install
Config folder .wgzero already exists, do you want to overwrite [y/N]: y
Available interfaces :
ens3
Interface [ens3]: 
Server [45.76.111.176]: 
Port [63350]: 
Subnet [10.10.0.1/24]: 
Specify private key [none]: 
Enable IPv6 [y/N]: 
Done, make sure 63350/UDP is open
```


# Other Commands
```
wgzero list
wgzero add clientname
wgzero del clientname
wgzero qr clientname
wgzero enable clientname
wgzero disable clientname
```

# FAQ, troubleshoot, etc.
## Initial steps on debian
```bash
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update && apt upgrade
apt install linux-headers-$(uname -r) wireguard curl qrencode iptables jq
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```

## Running alongside Pihole  
Run `pihole restartdns` after setup

## Usage with UFW
Suppose wireguard port is `51820` and gateway interface is `eth0`.
```bash
# 1. Allow incoming udp port
ufw allow 51820/udp 

# 2a. Allow traffic forwarding
ufw route allow in on wg0 out on eth0 

# 2b. Alternatively, you can allow all forwarding using
ufw default allow routed
```

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


### Example
```
root@vultr:~# ./wgzero install
Config folder .wgzero already exists, do you want to overwrite [y/N]: y
Available interfaces :
ens3
Interface [ens3]: 
Server [45.76.111.176]: 
Port [31407]: 
Subnet [10.10.0.1/24]: 
Specify private key [none]: 
Enable IPv6 [y/N]: y
IPv6 Prefix [fd00::]: 2a2a:fafa:caca:baba:dada::
IPv6 Subnet [64]: 80
External routing: 
[1] NAT
[2] Full Routing
Selection [1]: 2
Configure ndppd [y/N]: y
ndppd.service is not a native service, redirecting to systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ndppd
Done, make sure 31407/UDP is open
```
