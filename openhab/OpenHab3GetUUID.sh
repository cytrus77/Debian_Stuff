#!/bin/bash
#
# OpenHabGetUUID.sh
#

uuid=$(</var/lib/openhab/uuid)
echo "OpenHab UUID: $uuid"
secret=$(</var/lib/openhab/openhabcloud/secret)
echo "Openhab secret: $secret"
