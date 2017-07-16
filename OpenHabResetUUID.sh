#!/bin/bash
#
# OpenHabResetUUID.sh
#

echo "Removing OpenHab UUID file"
rm /var/lib/openhab2/uuid
echo "Removing Openhab secret file"
rm /var/lib/openhab2/openhabcloud/secret

echo "Done"
