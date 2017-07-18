#!/bin/bash
#
# HamachiResetId.sh
#

echo "Stopping Hamachi LogMeIn service"
systemctl stop logmein-hamachi.service

echo "Removing Hamachi ID file"
rm -r /var/lib/logmein-hamachi

echo "Starting Hamachi LogMeIn service"
systemctl start logmein-hamachi.service

echo "Done"
