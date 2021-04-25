# Prereqs (!! IMPORTANT)
- suppose provider gave IPv6 block of 2000:a:b:c::/64
- that block should only be allocated to one interface, wg0 in this case
- the main connection should have an IP outside that block, i.e. 2000:a:b::d/64
- else, clients will have no connection

Proceed only when `ping6 -I eth0 google.com` succeeds

# Configs
`ip a`
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether f2:3c:92:44:49:17 brd ff:ff:ff:ff:ff:ff
    inet 172.217.26.14/24 brd 172.217.26.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2404:6800:4004:999::f9f9/64 scope global 
       valid_lft forever preferred_lft forever
    inet6 fe80::f03c:92ff:fe44:4917/64 scope link 
       valid_lft forever preferred_lft forever
3: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none 
    inet 10.10.0.1/24 scope global wg0
       valid_lft forever preferred_lft forever
    inet6 2404:6800:4004:809::1/64 scope global 
       valid_lft forever preferred_lft forever
```

/etc/wireguard/wg0.conf
```
[Interface]
Address = 10.10.0.1/24, 2404:6800:4004:809::1/64
SaveConfig = false
PostUp = /usr/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; /usr/sbin/ip6tables -A FORWARD -i wg0 -j ACCEPT
PostDown = /usr/sbin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; /usr/sbin/ip6tables -D FORWARD -i wg0 -j ACCEPT
ListenPort = 51820
PrivateKey = CBN0q/QUnk2RvlQz535QyBPxdoxqmD0Qy4WMJtPqF14=

[Peer]
PublicKey = 4DaTbzokytwaxYrdwCMHWvbKL+EIdXWfqIvb6MGSsU0=
AllowedIPs = 10.10.0.2/32, 2404:6800:4004:809::2/128

[Peer]
PublicKey = RC6gRWSRi81bQOO7Hk8mYCkR5186EQEFTyiF4LoxYg4=
AllowedIPs = 10.10.0.3/32, 2404:6800:4004:809::3/128
```

someclient.conf
```
[Interface]
Address = 10.10.0.2/32, 2404:6800:4004:809::2/64
PrivateKey = 0OxNByLvxwvrWO+uDx5V9ly3LN9IDHYlQLA8hynABXk=

[Peer]
PublicKey = U/xxk7/RpibXvQgelFlCyYR887FvuYLkmsoauGMT6Tg=
Endpoint = 172.217.26.14:51820
AllowedIPs = 0.0.0.0/0, ::/0
```

# Final Tests
```bash
curl http://v4.ipv6-test.com/api/myip.php # ipv4 test
curl http://v6.ipv6-test.com/api/myip.php # ipv6 test
curl http://v4v6.ipv6-test.com/api/myip.php # dual stack, ipv6 means good to go

ping 2404:6800:4004:809::1 # check connection to peer
```