#!/bin/bash
#
# sipcmdInstall.sh
#

apt update
apt -y install libopal-dev libpt-dev

git clone https://github.com/cytrus77/sipcmd.git
cd sipcmd
make
cp sipcmd /usr/bin
cd ..
rm -rf sipcmd
