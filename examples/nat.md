/etc/wireguard/wg0.conf
```
[Interface]
Address = 10.10.0.1/24, fd00::1/64
SaveConfig = false
PostUp = /usr/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; /usr/sbin/ip6tables -t nat -A POSTROUTING -o IFACE -j MASQUERADE
PostDown = /usr/sbin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; /usr/sbin/ip6tables -t nat -D POSTROUTING -o IFACE -j MASQUERADE
ListenPort = 51820
PrivateKey = CBN0q/QUnk2RvlQz535QyBPxdoxqmD0Qy4WMJtPqF14=

[Peer]
PublicKey = 4DaTbzokytwaxYrdwCMHWvbKL+EIdXWfqIvb6MGSsU0=
AllowedIPs = 10.10.0.2/32, fd00::2/128
```

someclient.conf
```
[Interface]
Address = 10.10.0.2/32, fd00::2/64
PrivateKey = 0OxNByLvxwvrWO+uDx5V9ly3LN9IDHYlQLA8hynABXk=

[Peer]
PublicKey = U/xxk7/RpibXvQgelFlCyYR887FvuYLkmsoauGMT6Tg=
Endpoint = 1.2.3.4:51820
AllowedIPs = 0.0.0.0/0, ::/0
```