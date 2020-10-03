#!/bin/bash
# Simple Ping Monitor for hosts v0.3  | Charles Phillips | cphilllips.ia@gmail.com
#
# We parse this file to retrieve Hosts
LOCATION="KLECZKO"
EMAILID="cytrus77@gmail.com"

HOSTS_FILE="/usr/local/bin/monitor/hosts.list"
STATUS_FILE="/usr/local/bin/monitor/status_now"
DOWN_LATT_FILE="/usr/local/bin/monitor/down_last"

HOSTS_LIST=$(cat $HOSTS_FILE)
DOWN_NOW_LIST=()
DOWN_LAST_LIST=$(cat $DOWN_LATT_FILE)


## Check Hosts and compile a list of ones that may be unreachable
for myHost in $HOSTS_LIST;
  do
    echo "myHost = $myHost"
    IFS=';' read -ra ADDR <<< "$myHost"
    NAME=${ADDR[0]}
    IP=${ADDR[1]}

    ping -q -c 3 $IP > /dev/null
    if [ ! $? -eq 0 ]
      then
        if [[ ! " ${DOWN_LAST_LIST[@]} " =~ " ${IP} " ]]; then
            echo "$myHost failed"
            echo "Host: $NAME - [$IP] is unresponsive (ping failed)" >> $STATUS_FILE
        fi
        DOWN_NOW_LIST+=${IP}
    else
        if [[ " ${DOWN_LAST_LIST[@]} " =~ " ${IP} " ]]; then
            echo "$myHost back online"
            echo "Host: $NAME - [$IP] is back online" >> $STATUS_FILE
        fi
    fi
done

## Email that list and remove the file for next check
SUBJECT="[ALERT] [$LOCATION] Host(s) Unresponsive!"

#Send email and remove list
if [ -e $STATUS_FILE ];
  then
    echo "$(cat $STATUS_FILE)" | mail -s "$SUBJECT  $(date)" $EMAILID
    rm -rf $STATUS_FILE
fi

## check is last update list in file changed
diff=$(diff <(printf "%s\n" "${DOWN_NOW_LIST[@]}") <(printf "%s\n" "${DOWN_LAST_LIST[@]}"))

if [[ -z "$diff" ]]; then
    echo "Down now and last identical - exiting"
    exit 0
fi

## update last down list in file
if [ ! -z "$DOWN_NOW_LIST" ]
then
      echo $DOWN_NOW_LIST > $DOWN_LATT_FILE
else
      echo "DOWN NOW LIST is empty"
fi

exit 0
