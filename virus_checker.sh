#!/bin/bash

# Fix 1: Added a required space after the opening bracket '['
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)."
    exit 1
fi

# Fix 2: Added '-y' so the script doesn't hang waiting for user confirmation
apt install -y clamav
apt install -y chkrootkit # Fix 3: Corrected spelling from 'chrootkit' to 'chkrootkit'

echo "Starting ClamAV scan..."
# Optimization 1: 'tee' writes the full scan to the file, and passes the output to grep for the terminal
clamscan -r / | tee clamscanoutput.txt | grep 'FOUND'

echo "Starting chkrootkit scan..."
# Optimization 2: 'tee' outputs findings directly to the terminal AND saves to the file
chkrootkit -q | tee rootkitoutput.txt

echo "Scans complete!"