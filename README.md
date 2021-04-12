# WGZero
Zero overhead wireguard setup. Tested on Debian 10.

# Requirements
- [wireguard](https://www.wireguard.com/install/)
- curl
- qrencode
- iptables
- ipcalc

# Installation
```
curl -O https://github.com/finzzz/wgzero/raw/master/wgzero
chmod +x wgzero
./wgzero install
```

# Commands
```
wgzero install
wgzero list
wgzero add clientname
wgzero del clientname
wgzero qr clientname
```

# Troubleshoot
- Running alongside Pihole  
run `pihole restartdns` after setup
