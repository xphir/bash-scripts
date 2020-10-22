#!/bin/bash

# Elliot Schot - 2020

# Script aimed to help pass a disk directly to a VM

varversion=1.0
#V1.0: Initial Release - proof of concept

# USAGE
# You can run this scritp directly using:
# bash <(curl -Ss https://raw.githubusercontent.com/xphir/proxmox/master/onboard-gpu-passthrough.sh)
# wget https://raw.githubusercontent.com/xphir/proxmox/master/onboard-gpu-passthrough.sh
# chmod +x onboard-gpu-passthrough.sh
# ./onboard-gpu-passthrough.sh

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2020"
echo "Proxmox Onboard GPU Passthrough"
echo "----------------------------------------------------------------"

# TODO: Check bootloader type grub vs systemd-boot (it currently only supports system boot
echo "FOR systemd-boot only. If not using systemd-boot please ctrl + c now"
read -p "Press enter to continue"

# Add lines to systemd-boot
echo " intel_iommu=on i915.enable_gvt=1" >> /etc/kernel/cmdline
echo "enabled IOMMU & Inel GVT-g"

echo "Output from /etc/kernel/cmdline"
cat /etc/kernel/cmdline
read -p "Press enter to continue"

# Add Kernel Modules (for /etc/modules)
echo "
# Modules required for PCI passthrough
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd

# Modules required for Intel GVT
kvmgt
exngt
vfio-mdev
" >> /etc/modules

echo "Output from /etc/modules"
cat /etc/modules

read -p "Press enter to continue"

echo "Added Kernel Modules"

# Refresh initramfs
update-initramfs -u -k all

echo "Refreshed Iitramfs"

# Reboot
read -p "Press enter to reboot"
reboot
