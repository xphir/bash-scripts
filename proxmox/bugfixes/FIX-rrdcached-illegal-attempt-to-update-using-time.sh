#!/bin/bash

# Elliot Schot - 2020

varversion=1.0
#V1.0: Initial Release - proof of concept

# USAGE
# You can run this scritp directly using:
# bash <(curl -Ss https://raw.githubusercontent.com/xphir/proxmox/master/bugfixes/FIX-rrdcached-illegal-attempt-to-update-using-time.sh)

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2020"
echo "RRDC update error & RRD update error fix: illegal attempt to update using time"
echo "----------------------------------------------------------------"

# Add Kernel Modules (for /etc/modules)
echo "Stopping the rrdcached service"
service rrdcached stop 

echo "Removing /var/lib/rrdcached"
rm -rf /var/lib/rrdcached 

echo "Starting the rrdcached service"
service rrdcached start

echo "Showing the rrdcached service status"
service rrdcached status