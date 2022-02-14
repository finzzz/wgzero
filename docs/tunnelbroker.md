1. Create new tunnel https://tunnelbroker.net/new_tunnel.php
```
IPv4 Endpoint (Your side): <VPS Public IPv4>
Available Tunnel Servers: <Choose any>
```
2. Go to the tunnel and click `Assign /48`
3. Example config
```
IPv6 Tunnel Endpoints
Server IPv4 Address:74.82.46.6
Server IPv6 Address:2001:470:23:d::1/64
Client IPv4 Address:167.179.71.231
Client IPv6 Address:2001:470:23:d::2/64

Routed IPv6 Prefixes
Routed /64:2001:470:24:d::/64
Routed /48:2001:470:fc0b::/48

DNS Resolvers
Anycast IPv6 Caching Nameserver:2001:470:20::2
Anycast IPv4 Caching Nameserver:74.82.42.42
DNS over HTTPS / DNS over TLS:ordns.he.net
```
4. Add to /etc/network/interfaces
```
auto he-ipv6
iface he-ipv6 inet6 v4tunnel
    address 2001:470:23:d::2
    netmask 64
    endpoint 74.82.46.6
    local 167.179.71.231
    ttl 255
    gateway 2001:470:23:d::1
```
> restart network / reboot
5. At this point you should be able to connect to IPv6 sites
6. Install (choose arbitrary smaller block of 2001:470:fc0b::/48 i.e 2001:470:fc0b:c0d3::/64)
```
root@vultr:~# wgzero install
Wireguard Interface Name [wg0]: 
Available interfaces :
enp1s0
sit0
he-ipv6
Interface [enp1s0]: 
Endpoint [167.179.71.231]: 
ListenPort [49113]: 
Address [10.10.0.1/24]: 
MTU [1420]: 
Client MTU [1384]: 
DNS [unset]: 
KeepAlive [unset]: 
Specify private key [none]: 
Enable IPv6 [y/N]: y
IPv6 Prefix [fd00::]: 2001:470:fc0b:c0d3::
IPv6 Subnet [64]: 
External routing: 
[1] NAT
[2] Full Routing
Selection [1]: 2
Configure ndppd [y/N]: 
Created symlink /etc/systemd/system/multi-user.target.wants/wg-quick@wg0.service → /lib/systemd/system/wg-quick@.service.
Done, make sure 49113/UDP is open
```