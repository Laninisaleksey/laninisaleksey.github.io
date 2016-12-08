#!/bin/bash
#Preparing
echo -e "*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\nCOMMIT" > clear
iptables-restore < clear
rm clear

# Change the default chain policy to DROP, OUTPUT policy is ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE  
iptables -A FORWARD -i wlan1 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT  
iptables -A FORWARD -i eth1 -o wlan1 -j ACCEPT 

# Enable loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT

# Enable ICMP
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT

#
iptables -A INPUT -p TCP -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p UDP -m state --state ESTABLISHED,RELATED -j ACCEPT