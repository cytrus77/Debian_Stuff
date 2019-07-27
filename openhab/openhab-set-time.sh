#!/bin/sh
#
# Please edit the following lines to set your preferences and then run this script.
# To run the script type 'sudo bash ./install-openhab-arm64.sh |& tee install.log' without the quotes to send a full copy of the terminal output to file.
# Type 'sudo bash ./install-openhab-arm64.sh' without the quotes to not output to file as it may fix any display errors.
#

sudo locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
sudo dpkg-reconfigure tzdata
sudo apt-get install -y ntp

############### END OF SCRIPT ###################
