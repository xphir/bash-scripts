#!/bin/bash

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2020"
echo "Initial Plex VM Server Setup"
echo "----------------------------------------------------------------"

echo "Updating packages"
apt update

echo "Install NFS server, CIFS client & QEMU Guest Agent"
apt install nfs-kernel-server cifs-utils qemu-guest-agent -y

echo "Upgrading packages"
apt upgrade -y

echo "Upgrading distribution and autoremoving packages"
apt dist-upgrade -y && apt autoremove -y

echo "Installing Plexupdate"
bash -c "$(wget -qO - https://raw.githubusercontent.com/mrworf/plexupdate/master/extras/installer.sh)"

echo "Creating the publicshare group"
groupadd publicshare
echo "Added sysadmin to the publicshare group"
usermod -a -G publicshare sysadmin
echo "Added plex to the publicshare group"
usermod -a -G publicshare plex

echo "Gathering credentials file information"
read -e -p "Username for CIFS Mount (linux.admin): " -i "linux.admin" CREDENTIALS_USERNAME

read -e -p "Password for CIFS Mount: " CREDENTIALS_PASSWORD

read -e -p "Domain for CIFS Mount (xphir): " -i "xphir" CREDENTIALS_DOMAIN

echo "Create credentials file"
cat >> /var/.credentials <<EOL
username=${CREDENTIALS_USERNAME}
password=${CREDENTIALS_PASSWORD}
domain=${CREDENTIALS_DOMAIN}
EOL

echo "Lock credentials file"
chown root /var/.credentials
chmod 600 /var/.credentials

read -e -p "Server name for CIFS Mount (pentos.ad.xphir.com): " -i "pentos.ad.xphir.com" MOUNT_SERVER

read -e -p "Server path for CIFS Mount (/public/media): " -i "/public/media" MOUNT_PATH

read -e -p "Local Mount point CIFS Mount (/mnt/media): " -i "/mnt/media" MOUNT_POINT

echo "Making $MOUNT_POINT directory"
mkdir $MOUNT_POINT

echo "Mount CIFS Media Share for $MOUNT_SERVER"
cat >> /etc/fstab <<EOL

# Media Directory
//${MOUNT_SERVER}${MOUNT_PATH} $MOUNT_POINT cifs credentials=/var/.credentials,dir_mode=0775,file_mode=0775,gid=1001,uid=1000,vers=3.0,iocharset=utf8 0 0
EOL


echo "Mount NFS plex share"
cat >> /etc/exports <<EOL

# Plex media folder mount
/var/lib/plexmediaserver/Library/"Application Support"/"Plex Media Server"/Logs martell.ad.xphir.com(ro,sync,no_subtree_check)
EOL

echo "Mount shares"
mount -a