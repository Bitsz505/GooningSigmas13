#!/bin/bash

# Fix 1: Added a required space after the opening bracket '['
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)."
    exit 1
fi

install_deps_debian() {
  if command -v clamscan >/dev/null 2>&1 && command -v chkrootkit >/dev/null 2>&1; then
    echo "ClamAV and chkrootkit already installed."
    return 0
  fi

  echo "Installing ClamAV and chkrootkit (Debian/Ubuntu)..."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends clamav clamav-freshclam chkrootkit || return 1

  # Ensure freshclam service is enabled and update DB once
  systemctl enable --now clamav-freshclam >/dev/null 2>&1 || true
  freshclam || true

  return 0
}

# call it after the root check
install_deps_debian || { echo "Package installation failed. Exiting."; exit 1; }

#1. Update clamAV definitions
echo "Updating ClamAV definitions..."
echo ">>> Updating ClamAV definitions (freshclam)..."
#first we must stop the service so that freshclam can run
systemctl stop clamav-freshclam > /dev/null 2>&1
freshclam
systemctl start clamav-freshclam > /dev/null 2>&1
echo ">>> ClamAV definitions updated successfully."

#2. Run chkrootkit
echo "Hunting for rootkits with chkrootkit..."
chkrootkit -q
echo ">>> chkrootkit scan completed. If any rootkits were found, check their contents."

# 3. Directory Selection for ClamAV
echo "What would you like to scan for viruses?"
PS3="Choose a scan area (1-4): "
scan_options=("Scan Home Directory (/home)" "Scan Full System (/)" "Scan Custom Path" "Skip Virus Scan")

select choice in "${scan_options[@]}"
do
    case $choice in
        "Scan Home Directory (/home)")
            TARGET="/home"
            break
            ;;
        "Scan Full System (/)")
            echo "WARNING: Full system scan can take a long time."
            TARGET="/"
            break
            ;;
        "Scan Custom Path")
            read -p "Enter the full path you want to scan: " TARGET
            # Check if the directory exists
            if [ ! -d "$TARGET" ]; then
                echo "Error: $TARGET is not a valid directory. Try again."
                continue
            fi
            break
            ;;
        "Skip Virus Scan")
            echo "Skipping ClamAV scan."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done

echo "------------------------------------------"
echo ">>> Scanning $TARGET for Malware (clamscan)..."
clamscan -r -i "$TARGET"

echo "------------------------------------------"
echo "Scan process finished."