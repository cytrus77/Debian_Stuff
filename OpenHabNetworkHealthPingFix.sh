#!/bin/bash

# script fixing ping of NetworkHealth binding

JAVA=`which java`
JAVABIN=`ls -l $JAVA`
JAVABIN=${JAVABIN##*->}
JAVABIN2=`ls -l $JAVABIN`
JAVABIN2=${JAVABIN2##*->}
SETCAP="setcap cap_net_raw=ep $JAVABIN2"
echo $SETCAP
setcap cap_net_raw=ep $JAVABIN2

echo "Restarting Openhab2 service"
systemctl restart openhab2.service
