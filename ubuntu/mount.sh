#!/bin/bash

#You will need to enter the password when requested
#You will need cifs-utils installed

MOUNT_SERVER=//Braavos.ad.xphir.com
MOUNT_PATH=/Yoda
MOUNT_POINT=/mnt/yoda
MOUNT_USERNAME=linux.admin
MOUNT_DOMAIN=xphir

read -s -p "Enter ${MOUNT_DOMAIN}/${MOUNT_USERNAME} Password: " MOUNT_PASSWORD

printf "\n"

mkdir $MOUNT_POINT

echo "${MOUNT_SERVER}${MOUNT_PATH} ${MOUNT_POINT} cifs credentials=/var/.credentials,uid=1000,uid=1000 0 0" >> /etc/fstab

sudo touch /var/.credentials
cat >> /var/.credentials <<EOL
username=${MOUNT_USERNAME}
password=${MOUNT_PASSWORD}
domain=${MOUNT_DOMAIN}
EOL

sudo chown root /var/.credentials
sudo chmod 600 /var/.credentials

mount -a