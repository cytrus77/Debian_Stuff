#!/bin/sh
#
# Init.sh
#

service=BtSyncScheduler.sh
psOutout=$(ps | grep -v grep | grep $service | wc -l)
if [ "$psOutout" -gt 0 ]
then
    echo "$service is already running"
else
    echo "$service is not running - starting ..."
	/usr/local/zy-pkgs/etc/BtSyncScheduler.sh
fi

exit 0

