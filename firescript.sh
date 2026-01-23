#!/bin/bash

#---Check for root---
if ["$EUID" -ne 0]; then 
  echo "Please run this menu with sudo: sudo $0"
  exit 1
fi

#---Configuration---
PS3='Select a task(1-8): '
options=("Delete software" "Disable SSH" "Enable TCP Cookies" "Enable UFW" "Enact W Policies" "Update System" "Check for Viruses" "Quit")
