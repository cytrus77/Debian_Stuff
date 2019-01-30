#!/bin/bash
#
# OpenHabResetUUID.sh
#
echo "Stopping OpenHab service"
systemctl stop openhab2.service

echo "Removing OpenHab UUID file"
rm /var/lib/openhab2/uuid
echo "Removing Openhab secret file"
rm /var/lib/openhab2/openhabcloud/secret

echo "Starting OpenHab service"
systemctl start openhab2.service

echo "Done"
