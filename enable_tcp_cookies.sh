#!/bin/bash

#Check for root privileges
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root (use sudo)."
	exit 1
fi

echo "[+] Enabling IPc4 TCP SYN cookies

#This will allow me to enable IPv4 TCP SYN cookies
sysctl -w net.ipv4.tcp_syncookies=1
sed -i 's/^net.ipv4.tcp_syncookies./net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf
