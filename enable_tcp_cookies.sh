#!/bin/bash

#Check for root privileges
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root (use sudo)."
	exit 1
fi

echo "[+] Enabling IPv4 TCP SYN cookies"

#This will allow me to enable IPv4 TCP SYN cookies
sysctl -w net.ipv4.tcp_syncookies=1

# Persistently enable: replace existing setting or append if missing
if grep -qE '^net\.ipv4\.tcp_syncookies' /etc/sysctl.conf; then
	sed -i 's/^net\.ipv4\.tcp_syncookies.*/net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf
else
	echo 'net.ipv4.tcp_syncookies=1' >> /etc/sysctl.conf
fi

# Reload sysctl settings (best-effort)
sysctl -p >/dev/null 2>&1 || true
