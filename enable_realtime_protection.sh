#!/bin/bash

# --- Check for Root ---
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root."
    exit 1
fi

echo ">>> Installing prerequisites..."
apt update && apt install clamav-daemon -y

echo ">>> Configuring ClamAV for On-Access Scanning..."

# 1. Update clamd.conf to enable On-Access features
# We use 'sed' to ensure these specific lines exist in /etc/clamav/clamd.conf
CONFIG_FILE="/etc/clamav/clamd.conf"

# Enable ScanOnAccess
sed -i '/^ScanOnAccess/d' $CONFIG_FILE
echo "ScanOnAccess yes" >> $CONFIG_FILE

# Set the path to watch (usually /home is the most important)
sed -i '/^OnAccessIncludePath/d' $CONFIG_FILE
echo "OnAccessIncludePath /home" >> $CONFIG_FILE

# Set the user that clamonacc runs as (usually root to see all files)
sed -i '/^OnAccessUser/d' $CONFIG_FILE
echo "OnAccessUser root" >> $CONFIG_FILE

# Don't block the system if a scan takes a second
sed -i '/^OnAccessPrevention/d' $CONFIG_FILE
echo "OnAccessPrevention no" >> $CONFIG_FILE

echo ">>> Restarting ClamAV Daemon..."
systemctl restart clamav-daemon

echo ">>> Starting Real-Time Monitor (clamonacc)..."
# We start it as a background process
clamonacc

echo "------------------------------------------"
echo "SUCCESS: Real-time protection is now ACTIVE for /home."
echo "Note: This will stay active until you reboot."
echo "------------------------------------------"