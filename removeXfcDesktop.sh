#!/bin/bash

echo "Removing XFCE desktop"

apt -f install
apt clean
apt autoclean
apt update

apt -y purge xfce4

apt -y autoremove

echo "Done"
