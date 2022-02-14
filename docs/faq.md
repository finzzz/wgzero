### Initial steps on debian buster
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
