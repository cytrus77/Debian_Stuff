#!/bin/bash
#
# OpenHabInstall.sh
#

wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | apt-key add -
apt-get install -y apt-transport-https

echo 'deb https://dl.bintray.com/openhab/apt-repo2 stable main' | tee /etc/apt/sources.list.d/openhab2.list

apt-get update
apt-get install -y openhab2
apt-get install -y openhab2-addons

systemctl enable openhab2.service
systemctl start openhab2.service
