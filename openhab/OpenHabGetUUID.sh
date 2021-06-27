#!/bin/bash
#
# OpenHabGetUUID.sh
#

uuid=$(</var/lib/openhab2/uuid)
echo "OpenHab UUID: $uuid"
secret=$(</var/lib/openhab2/openhabcloud/secret)
echo "Openhab secret: $secret"

uuid=$(</var/lib/openhab/uuid)
echo "OpenHab UUID: $uuid"
secret=$(</var/lib/openhab/openhabcloud/secret)
echo "Openhab secret: $secret"
