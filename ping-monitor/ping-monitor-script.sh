#!/bin/bash

BIN_PATH="/usr/local/bin/monitor"
BIN_FILENAME="monitor.sh"
HOSTS_FILENAME="hosts.list"
DOWN_LAST_FILENAME="down_last"
MSMTP_CONF_FILENAME=".msmtprc"

apt update

apt install -y mailutils
apt install -y sendmail
apt install -y msmtp msmtp-mta
apt install -y bsd-mailx

mkdir -p $BIN_PATH

touch $BIN_PATH/$DOWN_LAST_FILENAME
cp ./$BIN_FILENAME $BIN_PATH/$BIN_FILENAME
cp ./$HOSTS_FILENAME $BIN_PATH/$HOSTS_FILENAME
cp ./$MSMTP_CONF_FILENAME ~/

chmod +x $BIN_PATH/$BIN_FILENAME
