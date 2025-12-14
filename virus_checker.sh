#!/bin/bash

sudo apt install clamav
clamscan

sudo apt install rkhunter
rkhunter --check

