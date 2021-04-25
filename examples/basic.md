/etc/wireguard/wg0.conf
```
[Interface]
Address = 10.10.0.1/24
SaveConfig = false
PostUp = /usr/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = /usr/sbin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820
PrivateKey = CBN0q/QUnk2RvlQz535QyBPxdoxqmD0Qy4WMJtPqF14=

[Peer]
PublicKey = 4DaTbzokytwaxYrdwCMHWvbKL+EIdXWfqIvb6MGSsU0=
AllowedIPs = 10.10.0.2/32
```

someclient.conf
```
[Interface]
Address = 10.10.0.2/32
PrivateKey = 0OxNByLvxwvrWO+uDx5V9ly3LN9IDHYlQLA8hynABXk=

[Peer]
PublicKey = U/xxk7/RpibXvQgelFlCyYR887FvuYLkmsoauGMT6Tg=
Endpoint = 1.2.3.4:51820
AllowedIPs = 0.0.0.0/0
```