#!/bin/bash

BundleID=`sshpass -p 'habopen' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no openhab@localhost -p8101 'bundle:list | grep "openHAB Cloud Connector"' | cut -c1-3`
sshpass -p 'habopen' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no openhab@localhost -p8101 "bundle:restart $BundleID"
