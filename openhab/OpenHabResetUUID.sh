#!/bin/bash
#
# OpenHabResetUUID.sh
#
echo "Stopping OpenHab service"
systemctl stop openhab.service

echo "Removing OpenHab UUID file"
rm /var/lib/openhab/uuid
echo "Removing Openhab secret file"
rm /var/lib/openhab/openhabcloud/secret

echo "Starting OpenHab service"
systemctl start openhab.service

echo "Done"
