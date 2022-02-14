1. IPv6 from vultr
```
Address
2401:c080:1000:4580:5400:03ff:feda:c8f5

Network
2401:c080:1000:4580::

Netmask
64

Default Gateway
(use router discovery)
```
2. /etc/network/interfaces
```
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp1s0
iface enp1s0 inet dhcp

iface enp1s0 inet6 static
    address 2401:c080:1000:4580:fefe::babe
    netmask 80
```
> reboot after changing network config
3. Install
```
root@vultr:~# wgzero install
Wireguard Interface Name [wg0]: 
Available interfaces :
enp1s0
Interface [enp1s0]: 
Endpoint [45.77.18.41]: 
ListenPort [15173]: 
Address [10.10.0.1/24]: 
MTU [1420]: 
Client MTU [1384]: 
DNS [unset]: 
KeepAlive [unset]: 
Specify private key [none]: 
Enable IPv6 [y/N]: y
IPv6 Prefix [fd00::]: 2401:c080:1000:4580:c0d3::
IPv6 Subnet [64]: 80
External routing: 
[1] NAT
[2] Full Routing
Selection [1]: 2
Configure ndppd [y/N]: y
ndppd.service is not a native service, redirecting to systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ndppd
Done, make sure 15173/UDP is open
```
4. Checking from client
```bash
curl http://v4.ipv6-test.com/api/myip.php # ipv4 test
curl http://v6.ipv6-test.com/api/myip.php # ipv6 test
curl http://v4v6.ipv6-test.com/api/myip.php # dual stack, ipv6 means good to go
```