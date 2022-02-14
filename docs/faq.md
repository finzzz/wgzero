### Initial steps on debian
```bash
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update && apt upgrade
apt install linux-headers-$(uname -r) wireguard curl qrencode iptables jq
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```

### Running alongside Pihole  
Run `pihole restartdns` after setup

### Usage with UFW
Suppose wireguard port is `51820` and gateway interface is `eth0`.
```bash
# 1. Allow incoming udp port
ufw allow 51820/udp 

# 2a. Allow traffic forwarding
ufw route allow in on wg0 out on eth0 

# 2b. Alternatively, you can allow all forwarding using
ufw default allow routed
```

### Full IPv6 routing on Hetzner and Vultr
***Install ndppd before proceeding***

#### Hetzner
By default, hetzner allocated a block of IPv6, such as `2a2a:fafa:caca:baba::/64`.  
But address `2a2a:fafa:caca:baba::1/64` is attached to the default network.  
So, in order for this to work, we need to split this block into smaller one.  
In this example, I will arbitrarily use `2a2a:fafa:caca:baba:dada::/80`.  

#### Vultr
Similar to hetzner, if you enabled IPv6, you can go to `Settings -> IPv6` section.  
The entry should be similar to this,  
| Address                   | Network               | Netmask | Default Gateway        |
| ------------------------- | --------------------- | ------- | ---------------------- |
| 2a2a:fafa:caca:baba::abcd | 2a2a:fafa:caca:baba:: | 64      | (use router discovery) |


#### Example
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

/etc/network/interfaces
```
auto ens3
iface ens3 inet dhcp

iface ens3 inet6 static
        address 2a2a:fafa:caca:baba:caca::1 # this must be in another subnet of IPv6 Prefix
        netmask 80
```

```
root@vultr:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,ALLMULTI,UP,LOWER_UP> mtu 1500 qdisc fq state UP group default qlen 1000
    link/ether 56:00:03:d8:e7:8e brd ff:ff:ff:ff:ff:ff
    inet 66.42.40.46/23 brd 66.42.41.255 scope global dynamic enp1s0
       valid_lft 86391sec preferred_lft 86391sec
    inet6 2a2a:fafa:caca:baba:caca::1/80 scope global 
       valid_lft forever preferred_lft forever
    inet6 fe80::5400:3ff:fed8:e78e/64 scope link 
       valid_lft forever preferred_lft forever
3: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none 
    inet 10.10.0.1/24 scope global wg0
       valid_lft forever preferred_lft forever
    inet6 2a2a:fafa:caca:baba:dada::336c/80 scope global 
       valid_lft forever preferred_lft forever
```

> 2a2a:fafa:caca:baba::1/64 shouldn't be assigned to ens3