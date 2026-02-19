#!/bin/bash

if ["$EUID" -ne 0 ]; then
	echo "Error: This script must be run as root (use sudo)."
	exit 1
fi
touch clamscanoutput.txt
touch rootkitoutput.txt

apt install clamav
clamscan > clamscanoutput.txt

apt install chrootkit
chrootkit -q > rootkitoutput.txt

grep 'FOUND' clamscanoutput.txt


