#!/bin/bash
echo -e "Select the operation:\n1)IPTABLES for VPN with log\n2)IPTABLES for VPN\n4)Standart IPTABLES \n5)BLOCK ALL\n6)Display IPTABLES\n7)Display INTERFACES\n8)Display CONNECTIONS"

read n
case $n in
	1) sudo ./for_vpn_log.sh;;
	2) sudo ./for_vpn.sh;;
	4) sudo ./trafic_on.sh;;
	5) sudo ./trafic_off.sh;;
	6) sudo iptables -L -v;;
	7) ifconfig;;
	8) netstat -at;;	
    *) invalid option;;
esac