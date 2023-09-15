#!/bin/bash

# OG Source: Tonton Jo
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# -----------------ENVIRONNEMENT VARIABLES----------------------
distribution=$(. /etc/*-release;echo $VERSION_CODENAME)
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

no_enterprise_repository() {
  echo "- Checking  Sources lists"
  if grep -Fq "deb http://download.proxmox.com/debian/pve" /etc/apt/sources.list; then
    echo "-- Source looks alredy configured - Skipping"
  else
    echo "-- Adding new entry to sources.list"
    sed -i "\$adeb http://download.proxmox.com/debian/pve $distribution pve-no-subscription" /etc/apt/sources.list
  fi
  echo "- Checking Enterprise Source list"
  if grep -Fq "#deb https://enterprise.proxmox.com/debian/pve" "/etc/apt/sources.list.d/pve-enterprise.list"; then
    echo "-- Entreprise repo looks already commented - Skipping"
  else
    echo "-- Hiding Enterprise sources list"
    sed -i 's/^/#/' /etc/apt/sources.list.d/pve-enterprise.list
    fi
        echo "- Checking Ceph Enterprise Source list"
      # Checking that source list file exist
  if [[ -f "/etc/apt/sources.list.d/ceph.list" ]]; then
          # Checking if it source is already commented or not
    if grep -Fq "#deb https://enterprise.proxmox.com/debian/ceph-quincy" "/etc/apt/sources.list.d/ceph.list"; then
            # If so do nothing
        echo "-- Ceph Entreprise repo looks already commented - Skipping"
    else
              # else comment it
        echo "-- Hiding Ceph Enterprise sources list"
        sed -i 's/^/#/' /etc/apt/sources.list.d/ceph.list
      fi
  fi
}

update () {
  echo "- Updating System"
  apt-get update -y -qq
  apt-get upgrade -y -qq
  apt-get dist-upgrade -y -qq
  if grep -Ewqi "no-subscription" /etc/apt/sources.list; then
    if grep -q ".data.status.toLowerCase() == 'active') {" $proxmoxlib; then
      echo "- Subscription Message already removed - Skipping"
    else
        echo "- Removing No Valid Subscription Message for PVE"
        sed -Ezi.bak "s/!== 'active'/== 'active'/" $proxmoxlib && echo "- Restarting proxy service" && systemctl restart pveproxy.service
    fi
  fi
}

no_enterprise_repository
update