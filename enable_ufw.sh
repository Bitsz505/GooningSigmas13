#!/bin/bash

#Check for root privileges
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root (use sudo)."
	exit 1
fi

echo "Attempting to start and enable the Uncomplicated Firewall (ufw)..."

#1. Start ufw automatically at boot
systemctl enable ufw

#2. Make ufw work ig
systemctl start ufw

#3. Check the status to verify
echo "---Verification Status---"
systemctl status ufw grep -E
"Active:|Loaded:"

echo "Ts is up and running"
