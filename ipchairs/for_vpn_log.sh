#!/bin/bash
#Preparing
echo -e "*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\nCOMMIT" > clear
iptables-restore < clear
rm clear

# Enable loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Logging (syslog, kernel.log)
#iptables -A INPUT -j LOG --log-prefix='[netfilter-input]'
#iptables -A OUTPUT -j LOG --log-prefix='[netfilter-output]'
#iptables -A FORWARD -j LOG --log-prefix='[netfilter-forward]'

# Interface where your local LAN is accessibble (check in terminal by exec "ifconfig")
GW_INT=enp0s3

# The VPN virtual interface (VPN interface from config file)
interface=`cat vpngate*.ovpn | grep -E "^dev" | awk '{print $2}'`
echo "Interface Parsed: "$interface
VPN_INT=tun0

# VPN server address (remote IP from VPN config file)
ip=`cat vpngate*.ovpn | grep -E "^remote" | awk '{print $2}'`
echo "IP Parsed: "$ip
VPN_SERVER=212.187.107.56

# VPN port address (remote IP/port from VPN config file)
port=`cat vpngate*.ovpn | grep -E "^remote" | awk '{print $3}'`
echo "Port Parsed: "$port
VPN_PORT=47

# Allow and LOG all traffic on VPN interface
iptables -A OUTPUT -o $VPN_INT -j LOG --log-prefix='[OUT FROM VPN INTERFACE]'
iptables -A INPUT -i $VPN_INT  -m state --state ESTABLISHED,RELATED -j LOG --log-prefix='[IN FROM VPN INTERFACE]'
iptables -A OUTPUT -o $VPN_INT -j ACCEPT
iptables -A INPUT -i $VPN_INT -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A INPUT  -i $VPN_INT -j ACCEPT

# Allow traffic to/from VPN server
iptables -A INPUT  -i $GW_INT -s $VPN_SERVER -p tcp --sport $VPN_PORT -j ACCEPT
iptables -A OUTPUT -o $GW_INT -d $VPN_SERVER -p tcp --dport $VPN_PORT -j ACCEPT

# Deny and LOG all traffic on gateway interface by default
iptables -N LOGGING_INPUT
iptables -N LOGGING_OUTPUT
iptables -A INPUT -j LOGGING_INPUT
iptables -A OUTPUT -j LOGGING_OUTPUT
iptables -A LOGGING_INPUT -j LOG --log-prefix='[BLOCKED IN]'
iptables -A LOGGING_OUTPUT -j LOG --log-prefix='[BLOCKED OUT]'
iptables -A LOGGING_INPUT -j DROP
iptables -A LOGGING_OUTPUT -j DROP


# Block IPv6 traffic
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP