#!/bin/sh
#
# BtSyncScheduler.sh
#

switchBtSync ()
{
    service=/usr/local/zy-pkgs/bin/btsync
    currentStatus="off"
    psOutout=$(ps | grep -v grep | grep $service | wc -l)
    if [ "$psOutout" -gt 0 ]
    then
        echo "$service is running"
        currentStatus="on"
    else
        echo "$service is not running"
    fi

    if [ $1 != $currentStatus ]
    then
        if [ $1 = "on" ]
        then
            echo "Starting $service"
            /etc/init.d/zypkg_controller.sh start
        elif [ $1 = "off" ]
        then
            echo "Stopping $service"
            /etc/init.d/zypkg_controller.sh stop
        else
            echo "Incorect operation. Please use on/off"
        fi
    fi
}

echo "BtSync scheduler started"

while true
do
    if [[ $(date +%u) -gt 5 ]] # check if it's weekend
    then
        echo "It's weekend. Turning sync on"
        switchBtSync on
    elif [[ $(date +%H) -gt 19 ]]
    then
        echo "It's after 20h. Turning sync on"
        switchBtSync on
    elif [[ $(date +%H) -lt 6 ]]
    then
        echo "It's before 6h. Turning sync on"
        switchBtSync on
    else
        echo "It's working hours. Turning sync off"
        switchBtSync off
    fi

    sleep 600
done

exit 0

