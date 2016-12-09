#!/bin/bash
ip=`cat vpngate*.ovpn | grep -E "^remote" | awk '{print $2}'`
echo "IP Parsed: "$ip >> variables.txt
port=`cat vpngate*.ovpn | grep -E "^remote" | awk '{print $3}'`
echo "Port Parsed: "$port >> variables.txt
interface=`cat vpngate*.ovpn | grep -E "^dev" | awk '{print $2}'`
echo "Interface Parsed: "$interface >> variables.txt