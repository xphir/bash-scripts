#!/bin/bash

varversion=1.0
#V1.0: Initial Release - proof of concept

# USAGE
# You can run this scritp directly using:
# wget https://raw.githubusercontent.com/TODO
# bash install-docker.sh

CURRENT_USER=$(who am i | awk '{print $1}')

echo "----------------------------------------------------------------"
echo "Elliot Schot - 2020"
echo "Docker CE Installer"
echo "----------------------------------------------------------------"

echo "Updating your existing list of packages"
apt update

echo "Installing a few prerequisite packages which let apt use packages over HTTPS"
apt install apt-transport-https ca-certificates curl software-properties-common

echo "Adding the GPG key for the official Docker repository to your system"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Adding the Docker repository to APT sources"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

echo "Updating the package database with the Docker packages from the newly added repo"
apt update

echo "Installing Docker"
apt install docker-ce

echo "Adding ${USER} username to the docker group"
usermod -aG docker $CURRENT_USER

echo "Adding ${USER} username to the docker group"
su - $CURRENT_USER

echo "Install complete"