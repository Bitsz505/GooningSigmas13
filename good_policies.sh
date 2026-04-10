#!/bin/bash

#This script is to enable good policies.

#This is to require the command to be run as root or with sudo
if [ "$EUID" -ne 0 ]; then
	echo "ERROR: This command be run as root."
	exit 1
fi

#First, we want to be able to change our minimum password length. That's why the necessary argument is for passowrd length.
PAM_FILE="/etc/pam.d/common-password"

#The following function will do the bulk of the work for setting the password.
set_minlen() {
	local new_minlen=$1

	#Checks if the file exists
	if [ ! -f "$PAM_FILE" ]; then
		echo "Error: PAM configuration file not found at $PAM_FILE"
		exit 1
	fi

	echo "Setting minimum password length to $new_minlen in $PAM_FILE"

	#1. Back up original file
	cp   "$PAM_FILE" "$PAM_FILE.bak.$(date +%Y%m%d%H%M%S)"
	echo "Backup created at $PAM_FILE.bak ..."

	#2. Use sed to replace 'minlen=X' or add 'minlen=Y' to the pam_unix.so line
	# This sed command searches for the line containing 'pam_unix.so' and either:
	# a) replaces an existing 'minlen=X' with 'minlen=Y'
	# b) or appends 'minlen=Y' before the final space/newline of the line if no minlen exists
	#The script uses a placeholder then a second sed command to avoid combining complex logic

	#First, replace any existing minlenor set a placeholder
	sed -i '/pam_unix\.so/s/minlen=[0-9]*/REPLACE_MINLEN/' "$PAM_FILE"

	#Second, substitute the place holder w/ a new value or append a new value
	sed -i '/pam_unix\.so/ {
		/REPLACE_MINLEN/ { s/REPLACE_MINLEN/minlen='$new_minlen'/ }
		//! s/pam_unix/.so\(.*\)/pam_unix\.so\1 minlen ='$new_minlen'/
	}' "$PAM_FILE"

	echo "Configuration updated successfully. New policies will apply upon the next password change."

	#Check if the line contains the new minlen
	if grep -q "pam_unix\.so*minlen=$new_minlen" "$PAM_FILE"; then
		echo "Verification: 'minlen=$new_minlen' is present"
	else
		echo "Warning Veification failed. Please check the file manually"
	fi

}

#Now we can FINALLY execute the file(It took me a while to write ts)

set_minlen "$1"

#Next, we're going to change the requirements for passwords

sed -i '165s/99999/30/g' /etc/login.defs
sed -i '166s/0/7/g' /etc/login.defs

echo "
ocredit=1
ucredit=1
lcredit=1
dcredit=1
minlen=12" >> /etc/login.defs

#That's all for the password stuff. Next is our root stuff

#The following command disables root login
sed -i 's/PermitRootLogin[[:space:]]yes/PermitRootLogin[[:space:]]no/g' /etc/login.defs

#Lastly, let's make sure sudo requires authentication for use
sed -i '11 a\Defaults[[:space:]]authenticate' /etc/sudoers

#That's all for now, prob gonna add more later
