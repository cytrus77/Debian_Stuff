#!/bin/bash
# Simple Ping Monitor for hosts v0.3  | Charles Phillips | cphilllips.ia@gmail.com
#
# We parse this file to retrieve Hosts
LOCATION="MAKO"
EMAILID="cytrus77@gmail.com"

HOSTS_FILE="/usr/local/bin/monitor/hosts.list"
STATUS_FILE="/usr/local/bin/monitor/status_now"
DOWN_LAST_FILE="/usr/local/bin/monitor/down_last"

HOSTS_LIST=$(cat $HOSTS_FILE)
declare -A RECOVERED_LIST
DEGRADEDED_LIST=()
declare -A DOWN_NOW_LIST
readarray DOWN_LAST_LIST < $DOWN_LAST_FILE


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
        DEGRADEDED_FLAG=1
        DOWN_NOW_LIST[$NAME]="${IP}"

        for DOWN_IP in "${DOWN_LAST_LIST[@]}"
        do
            DOWN_IP=${DOWN_IP%$'\n'}
            if [[ "$DOWN_IP" == "$IP" ]]; then
                DEGRADEDED_FLAG=0
                break
            fi
        done

        if [ "$DEGRADEDED_FLAG" -eq "1" ]; then
            DEGRADEDED_LIST[${#DEGRADEDED_LIST[@]}]="${IP}"
        fi
    else
        for DOWN_IP in "${DOWN_LAST_LIST[@]}"
        do
            DOWN_IP=${DOWN_IP%$'\n'}
            if [[ "$DOWN_IP" == "$IP" ]]; then
                RECOVERED_LIST[$NAME]="${IP}"
                break
            fi
        done
    fi
done


if [[ "${#RECOVERED_LIST[@]}" -gt "0" ]] || [[ ! -z "$DEGRADEDED_LIST" ]]
then
    for NAME in "${!RECOVERED_LIST[@]}"
    do
        IP=${RECOVERED_LIST[$NAME]}
        echo "$NAME - $IP back ONLINE"
        echo -e "[$IP]\t$NAME\tback ONLINE" >> $STATUS_FILE
    done

    echo "=============================================================="

    for NAME in "${!DOWN_NOW_LIST[@]}"
    do
        IP=${DOWN_NOW_LIST[$NAME]}
        echo "$NAME - $IP FAILED"
        echo -e "[$IP]\t$NAME\tunresponsive (ping FAILED)" >> $STATUS_FILE
    done
fi


## Email that list and remove the file for next check
R_COUNT=${#RECOVERED_LIST[@]}
F_COUNT=${#DOWN_NOW_LIST[@]}
SUBJECT="[ALERT] [$LOCATION] Recovered=[$R_COUNT] Unresponsive=[$F_COUNT]"

#Send email and remove list
if [ -e $STATUS_FILE ];
  then
    echo "$(cat $STATUS_FILE)" | mail -s "$SUBJECT  $(date)" $EMAILID
    echo "Notification sent"
    rm -rf $STATUS_FILE
fi

## check is last update list in file changed
diff=$(diff <(printf "%s\n" "${DOWN_NOW_LIST[@]}") <(printf "%s\n" "${DOWN_LAST_LIST[@]}"))

if [[ -z "$diff" ]]; then
    echo "Down now and last identical - exiting"
    exit 0
fi


## update last down list in file
if [ "${#DOWN_NOW_LIST[@]}" -gt "0" ]
then
    printf "%s\n" "${DOWN_NOW_LIST[@]}" > $DOWN_LAST_FILE
else
    echo "DOWN NOW LIST is empty"
fi

exit 0
