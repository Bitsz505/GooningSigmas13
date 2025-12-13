#!/bin/bash

#This script changes password requirements

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)." | tee -a "$LOG_FILE"
    exit 1
fi

sed -i '165s/99999/30/g' login.defs
sed -i '166s/0/7/g' login.defs

echo "ocredit=1
ucredit=1
lcredit=1
dcredit=1
minlen=12" >> /etc/login.defs

