#!/bin/bash

apt update
apt upgrade -y

apt install -y default-jre

wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add -
apt-get install apt-transport-https
echo 'deb https://dl.bintray.com/openhab/apt-repo2 stable main' | sudo tee /etc/apt/sources.list.d/openhab2.list

apt update
apt install -y openhab2
apt install -y openhab2-addons

systemctl daemon-reload
systemctl enable openhab2.service
systemctl start openhab2.service
systemctl status openhab2.service
