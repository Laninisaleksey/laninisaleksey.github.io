#!/bin/bash
#Preparing
echo -e "*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\nCOMMIT" > clear
iptables-restore < clear
rm clear

# Change the default chain policy to DROP, OUTPUT policy is ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE  
sudo iptables -A FORWARD -i wlan1 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i eth1 -o wlan1 -j ACCEPT  



#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN
# Enable loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT
iptables -A OUTPUT -o lo -j ACCEPT

# Enable ICMP. Uncomment if OUTPUT policy is DROP
iptables -A INPUT -p icmp -j ACCEPT
#iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
#iptables -A OUTPUT -p icmp -j ACCEPT

# On messages from services
iptables -A INPUT -p TCP -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p UDP -m state --state ESTABLISHED,RELATED -j ACCEPT

# Open ports
iptables -A INPUT -m multiport -p tcp --dports 80,443,53 -j ACCEPT
iptables -A INPUT -m multiport -p udp --dports 80,443,53 -j ACCEPT

#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN
#!!! Comment this strings, if use VPN

#iptables -A INPUT -j REJECT
#iptables -A FORWARD -j REJECT
#iptables -A OUTPUT -j REJECT



