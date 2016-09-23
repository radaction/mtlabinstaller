#!/bin/bash

# This script is an installer to Networking Mikrotik Laboratory
# on Ubuntu 16.04 LTS 
# @author Tiago Arnold <tiago at radaction.com.br>
# @version 1.0
# You don't need licence to use it, take all free.
# command to install the lab enviroment:
# curl -L http://goo.gl/sRhyzH | sudo bash

if (($EUID != 0)); then
  echo "Please run with sudo..."
  exit
fi

export DEBIAN_FRONTEND=noninteractive
echo -e "\n\nInstalling and configure the packages dependencies to GNS3..."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >   /etc/apt/sources.list.d/docker.list
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
echo wireshark wireshark-common/install-setuid boolean true | debconf-set-selections
echo wireshark-common	wireshark-common/install-setuid	boolean	true | debconf-set-selections
apt-get update
apt-get install -q -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils \
vlan git virt-manager vim-nox python3-dev python3-setuptools python3-pyqt5 \
python3-pyqt5.qtsvg python3-pyqt5.qtwebkit python3-ws4py python3-netifaces \
python3-pip build-essential cmake uuid-dev libelf-dev libpcap-dev wireshark \
tcpdump playonlinux cpulimit apt-transport-https ca-certificates linux-image-extra-$(uname -r) \
linux-image-extra-virtual docker-engine x11vnc xvfb konsole


echo -e "\n\nDownloading the sources and dependencies to GNS3..."
mkdir ~/sources
cd ~/sources
git clone https://github.com/GNS3/dynamips.git
git clone https://github.com/GNS3/vpcs.git
git clone https://github.com/GNS3/gns3-gui.git
git clone https://github.com/GNS3/gns3-server.git
git clone https://github.com/GNS3/ubridge.git

echo -e "\n\nInstalling the Dynamips..."
cd ~/sources/dynamips
mkdir build
cd build
cmake ..
make
make install

echo -e "\n\nSetting the low level network permission..."

setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/dynamips
setcap cap_net_admin,cap_net_raw=ep /usr/bin/qemu-system-i386
setcap cap_net_admin,cap_net_raw=ep /usr/bin/qemu-system-x86_64
setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap

echo -e "\n\nInstalling the VPCS..."
cd ~/sources/vpcs/src
./mk.sh
mv vpcs /usr/local/bin/

echo -e "\n\nInstalling the GNS3 Server..."
cd ~/sources/gns3-server
python3 setup.py install

echo -e "\n\nInstalling the GNS3 GUI..."
cd ~/sources/gns3-gui
python3 setup.py install

echo -e "\n\nInstalling the uBridge..."
cd ~/sources/ubridge
make
make install

echo -e "\n\nIntalling Docker..."
usermod -aG docker $SUDO_USER

echo -e "\n\nDownload mikrotik Image to virtualize..."
cd ~/sources
wget http://download2.mikrotik.com/routeros/6.34.6/chr-6.34.6.img.zip
unzip chr-6.34.6.img.zip
rm -rf chr-6.34.6.img.zip

echo -e "\n\nConfig QEMU ..."
curl -L https://raw.githubusercontent.com/radaction/mtlabinstaller/master/qemu-ifup > /etc/qemu-ifup

echo -e "\n\nSetup the user system to use low level network tools..."
echo "$SUDO_USER  ALL=(ALL) NOPASSWD: /bin/ip" >> /etc/sudoers

chown -R $SUDO_USER:$SUDO_USER ~/sources
usermod -a -G wireshark $SUDO_USER

echo -e "\n\nFinished, enjoy..."
