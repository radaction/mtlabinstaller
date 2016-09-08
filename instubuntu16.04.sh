#!/bin/bash
# This script is an installer to Networking Mikrotik Laboratory
# on Ubuntu 16.04 LTS 
# @author Tiago Arnold <tiago at radaction.com.br>
# You don't need licence to use it, take all free.

DEBIAN_FRONTEND=noninteractive

echo "Installing and configure the packages dependencies to GNS3..."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >   /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install --assume-yes -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils \
vlan git virt-manager vim-nox python3-dev python3-setuptools python3-pyqt5 \
python3-pyqt5.qtsvg python3-pyqt5.qtwebkit python3-ws4py python3-netifaces \
python3-pip build-essential cmake uuid-dev libelf-dev libpcap-dev wireshark \
tcpdump playonlinux cpulimit apt-transport-https ca-certificates linux-image-extra-$(uname -r) \
linux-image-extra-virtual


echo "Downloading the sources and dependencies to GNS3..."
mkdir ~/sources
cd ~/sources
git clone https://github.com/GNS3/dynamips.git
git clone https://github.com/GNS3/vpcs.git
git clone https://github.com/GNS3/gns3-gui.git
git clone https://github.com/GNS3/gns3-server.git
git clone https://github.com/GNS3/ubridge.git

echo "Installing the Dynamips..."
cd ~/sources/dynamips
mkdir build
cd build
cmake ..
make
make install

echo "Setting the low level network permission..."

setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/dynamips
setcap cap_net_admin,cap_net_raw=ep /usr/bin/qemu-system-i386
setcap cap_net_admin,cap_net_raw=ep /usr/bin/qemu-system-x86_64

echo "Installing the VPCS..."
cd ~/source/vpcs/src
./mk.sh
mv vpcs /usr/local/bin/

echo "Installing the GNS3 Server..."
cd ~/sources/gns3-server
python3 setup.py install

echo "Installing the GNS3 GUI..."
cd ~/sources/gns3-gui
python3 setup.py install

echo "Installing the uBridge..."
cd ~/source/ubridge
make
make install

echo "Intalling Docker..."
apt-get install -y docker-engine
groupadd docker
usermod -aG docker $USER

echo "Download mikrotik Image to virtualize..."
cd ~/source
wget http://download2.mikrotik.com/routeros/6.34.6/chr-6.34.6.img.zip
unzip chr-6.34.6.img.zip
