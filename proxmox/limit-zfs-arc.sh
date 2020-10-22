#!/bin/bash

# Elliot Schot - 2020

# Script aimed to limit zfs arc max

varversion=1.0
#V1.0: Initial Release - proof of concept

# USAGE
# You can run this scritp directly using:
# bash <(curl -Ss https://raw.githubusercontent.com/xphir/proxmox/master/limit-zfs-arc.sh)

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2020"
echo "Limit ZFS Arc Max"
echo "----------------------------------------------------------------"

# Add Kernel Modules (for /etc/modules)
cat >> /etc/modprobe.d/zfs.conf <<EOL
# Max 4096 MB Limit
# options zfs zfs_arc_min=2147483648
options zfs zfs_arc_max=4294967296
EOL

# Reboot
reboot
