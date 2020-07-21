# simple_wireguard
Tested on Ubuntu 18.04. For other distributions, make sure [wireguard](https://www.wireguard.com/install/) and [qrencode](https://pkgs.org/download/qrencode) are installed before proceeding.

### 1. Clone this repo  
```
git clone https://github.com/finzzz/simple_wireguard.git
```

### 2. Navigate to the directory  
```
cd simple_wireguard
```
          
### 3. Make executable
```
chmod +x simple_wg.sh
```
         
### 4. Run
#### automatically choose network interface
```
./simple_wg.sh init
```
  
#### manually choose network interface
```
ip -c -4 -br a | grep UP
```
then  
```
./simple_wg.sh init eth0
```

***
### Add client
```
./simple_wg.sh add john 10.10.10.5
```
  
***
### Delete client
```
./simple_wg.sh del john
```

***
### List clients
```
./simple_wg.sh list
```
  
***
### Show client's QR code config
```
./simple_wg.sh qr john
```

***
### Use custom domain (during init)
```
./simple_wg.sh init eth0 mysite.com
```
or  
```
./simple_wg.sh init mysite.com
```

***
### Alongside Pihole
run `pihole restartdns` after setup
