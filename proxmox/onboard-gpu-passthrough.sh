#!/bin/bash

# Elliot Schot - 2023

# Script aimed to help pass a disk directly to a VM

varversion=1.1
#V1.0: Initial Release - proof of concept

# USAGE
# You can run this scritp directly using:
# bash <(curl -Ss https://raw.githubusercontent.com/xphir/proxmox/master/onboard-gpu-passthrough.sh)
# wget https://raw.githubusercontent.com/xphir/proxmox/master/onboard-gpu-passthrough.sh
# chmod +x onboard-gpu-passthrough.sh
# ./onboard-gpu-passthrough.sh

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2023"
echo "Proxmox Onboard GPU Passthrough"
echo "----------------------------------------------------------------"

# This should only pass if we are using both UEFI mode and systemd-boot (ie UEFI & ZFS) - Source: https://pve.proxmox.com/wiki/Host_Bootloader#sysboot_determine_bootloader_used
if efibootmgr -v &> /dev/null && efibootmgr | grep "Linux Boot Manager" &> /dev/null; then
    echo "systemd-boot bootloader found."
    # Add lines to systemd-boot
    echo " intel_iommu=on iommu=pt i915.enable_gvt=1" >> /etc/kernel/cmdline
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
    xengt
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
else
    # TODO Add support for grub
    echo "Error: invalid bootloader not found."
    echo "FOR systemd-boot only. If not using systemd-boot please ctrl + c now"
    read -p "Press enter to exit..."
fi