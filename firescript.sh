#!/bin/bash

#---Check for root---
if [ "$EUID" -ne 0 ]; then 
  echo "Please run this menu with sudo: sudo $0"
  exit 1
fi

#---Configuration---
PS3='Select a task(1-8): '
options=("Delete Software" "Disable SSH" "Enable TCP Cookies" "Enable UFW" "Enact W Policies" "Update System" "Check for Viruses" "Quit")

#---Menu Loop---
clear
echo "==============================="
echo "     LINUX MANAGEMENT MENU     "
echo "==============================="

select opt in "${options[@]}"
do
  case $opt in
    "Delete Software")
      dos2unix bulk_delete_software.sh
      chmod +x bulk_delete_software.sh
      read -p "Enter package name(s) to delete (space seperated):  " pkgs
      # Calling the deletion script
      ./bulk_delete_software.sh $pkgs
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Disable SSH")
      dos2unix disable_ssh.sh
      chmod +x disable_ssh.sh
      echo "Disabling SSH Service.."
      # Calling SSH script
      ./disable_ssh.sh
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enable TCP Cookies")
      dos2unix enable_tcp_cookies.sh
      chmod +x enable_tcp_cookies.sh
      echo "Enabling TCP Cookies..."
      # Calling Cookie script
      ./enable_tcp_cookies.sh
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enable UFW")
      dos2unix enable_ufw.sh
      chmod +x enable_ufw.sh
      echo "Enabling UFW..."
      # Calling UFW Script
      ./enable_ufw.sh
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Enact W Policies")
      dos2unix good_policies.sh
      chmod +x good_policies.sh
      read -p "Enter desired minimum length (e.g., 120: " passlen
      # Calling the script with the input as an argument
      ./good_policies.sh "$passlen"
      echo "Press Enter to return to menu..."
      read 
      ;;
      
    "Update System")
      dos2unix system_updater.sh
      chmod +x system_updater.sh
      echo "Updating your system..."
      #Calling sys update script
      ./system_updater.sh
      echo "Press Enter to return to menu..."
      read 
      ;;

    "Check for Viruses")
      dos2unix virus_checker.sh
      chmod +x virus_checker.sh
      echo "Running virus check..."
      #Calling virus checker sceipr
      ./virus_checker.sh
      echo "Press Enter to return to menu..."
      read 
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