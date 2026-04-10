#!/bin/bash

#---Check for root---
if [ "$EUID" -ne 0 ]; then 
  echo "Please run this menu with sudo: sudo $0"
  exit 1
fi

#---This finds directory where script is located
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

#---Configuration---
PS3='Select a task(1-9): '
options=("Delete Software" "Disable SSH" "Enable TCP Cookies" "Enable UFW" "Enact W Policies" "Update System" "Check for Viruses" "Enable Real-Time Protection" "Quit")

 #Pre-Check
 #This fixes line endings for all scripts in the directory to prevent issues with running them on Linux
echo "Preparing scriprs for execution..."
dos2unix "$SCRIPT_DIR"/*.sh > /dev/null 2>&1
chmod +x "$SCRIPT_DIR"/*.sh
echo "Preparation complete. Launching menu..."

#---Menu Loop---
clear
echo "==============================="
echo "     LINUX MANAGEMENT MENU     "
echo "==============================="

select opt in "${options[@]}"
do
  case $opt in
    "Delete Software")  
      read -p "Enter package name(s) to delete (space seperated):  " pkgs
      # Calling the deletion script
      "$SCRIPT_DIR/bulk_delete_software.sh" $pkgs
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Disable SSH")
      echo "Disabling SSH Service.."
      # Calling SSH script
      "$SCRIPT_DIR/disable_ssh.sh"
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enable TCP Cookies")
      echo "Enabling TCP Cookies..."
      # Calling Cookie script
      "$SCRIPT_DIR/enable_tcp_cookies.sh"
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enable UFW")
      echo "Enabling UFW..."
      # Calling UFW Script
      "$SCRIPT_DIR/enable_ufw.sh"
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enact W Policies")
      read -p "Enter desired minimum length (e.g., 12): " passlen
      # Calling the script with the input as an argument
      "$SCRIPT_DIR/good_policies.sh" "$passlen"
      echo "Press Enter to return to menu..."
      read 
      ;;
      
    "Update System")
      echo "Updating your system..."
      #Calling sys update script
      "$SCRIPT_DIR/system_updater.sh"
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Check for Viruses")
      echo "Running virus check..."
      #Calling virus checker script
      "$SCRIPT_DIR/virus_checker.sh"
      echo "Press Enter to return to menu..."
      read 
      ;;
      
    "Enable Real-Time Protection")
      echo "Enabling real-time protection..."
      "$SCRIPT_DIR/enable_realtime_protection.sh"
      ;;
      
    "Quit")
      echo "Exiting."
      break
      ;;
      
    *)
      echo "Invalid. Please try again."
      ;;
      
  esac
  clear
  echo "==============================="
  echo "     LINUX MANAGEMENT MENU     "
  echo "==============================="
  echo "Current Selection: $opt (Last Task Completed)"
  echo "-------------------------------"
done