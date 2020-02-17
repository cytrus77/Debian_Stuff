#!/bin/bash

apt update
apt upgrade -y

apt install -y default-jre
apt install -y openhab2
apt install -y openhab2-addons

systemctl daemon-reload
systemctl enable openhab2.service
systemctl start openhab2.service
systemctl status openhab2.service
