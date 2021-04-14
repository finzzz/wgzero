# WGZero
Zero overhead wireguard setup. Tested on Debian 10.

# Requirements
- [wireguard](https://www.wireguard.com/install/)
- curl
- qrencode
- iptables
- ipcalc

# Installation
```bash
curl -sO https://raw.githubusercontent.com/finzzz/wgzero/0.1/wgzero
chmod +x wgzero
./wgzero install
```

![](screenshots/install.png)


# Other Commands
```
wgzero add clientname
wgzero del clientname
wgzero list
wgzero qr clientname
```
![](screenshots/add.png)
![](screenshots/list.png)


# Troubleshoot
- Initial steps on debian
```bash
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
apt update && apt upgrade
apt install linux-headers-$(uname -r) wireguard qrencode ipcalc curl iptables
# replace linux-headers-$(uname -r) with linux-headers-amd64 if errors
```
- Running alongside Pihole  
Run `pihole restartdns` after setup
