#! /usr/bin/env bash

# ipv4
/usr/sbin/iptables -t nat -D POSTROUTING -o IFACE -j MASQUERADE

# ipv6
if [ "$1" == "NAT" ]; then
    /usr/sbin/ip6tables -t nat -D POSTROUTING -o IFACE -j MASQUERADE
elif [ "$1" == "FR" ]; then
    /usr/sbin/ip6tables -D FORWARD -i wg0 -j ACCEPT
fi