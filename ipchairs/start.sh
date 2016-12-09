#!/bin/bash
echo -e "Select the operation:\n1)IPTABLES for VPN 1\n2)Standart IPTABLES \n3)BLOCK ALL\n4)Display IPTABLES\n5)Display INTERFACES\n6)Display CONNECTIONS"

read n
case $n in
	1) sudo ./for_vpn_log.sh;;
	2) sudo ./trafic_on.sh;;
	3) sudo ./trafic_off.sh;;
	4) sudo iptables -L -v;;
	5) ifconfig;;
	6) netstat -at;;	
    *) invalid option;;
esac