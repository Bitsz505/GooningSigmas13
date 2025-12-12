#!/usr/bin/bash

#---Configuration---
#Package Manager for Debian/Ubuntu-based systems
PKG_MANAGER="apt"

#---Functions---

#Funtion to display usage information
usage() {
	echo "Usage: sudo $0 <package_name_1> [package_name_2] ..."
	echo "Deletes one or more software packages (using 'purge') and cleans up dependencies
	echo "Example: sudo $0 firefox gimp
	exit 1
}

#Check if any package names were provided
if [ "$#" -eq 0 ]; then
	usage
fi


#Check for root privileges
if ["$EUID" -ne 0 ]; then
	echo "Error: This script must be run as root (use sudo)."
	exit 1
fi

echo "---Starting Software Deletion---"

#Loop through all input arguments (package names)
for PACKAGE_NAME in "$@"; do 
	echo ">>> Processing package: $PACKAGE_NAME"

	#1. Check if the package is currently installed
	if dpkg -l "$PACKAGE_NAME" 2>/dev/null | grep -q "^ii"; then
		echo "Package '$PACKAGE_NAME' found and installed. Purging..."

		#Use 'purge' to remove package and configuration files
		if $PKG_MANAGER purge -y "$PACKAGE_NAME"; then
			echo "SUCCESS: '$PACKAGE_NAME' has been purged."
		else
			echo "ERROR: Failed to purge package '$PACKAGE_NAME'. See Output above"
		fi
	else
		echo "Note: Package '$PACKAGE_NAME' is not installed or the name is incorrect. Skipping."
	fi
	echo "---"
done

#2. Clean up unused dependencies
echo ">>> Running $PKG_MANAGER autoremove to clean up orphaned dependencies..."
if $PKG_MANAGER autoremove -y; then
	echo "SUCCESS: Unused dependencies have been removed."
else
	echo"Note: No unused packages to remove, or autoremove failed."
fi

#3. Clear the downloaded package cache (optional but recommended)
echo ">>>Running $PKG_MANAGER clean to clear the local package cache..."
$PKG_MANAGER clean 
echo "SUCCESS: Local package cache cleared."

echo " "
echo "---Deletion Process Complete---"
