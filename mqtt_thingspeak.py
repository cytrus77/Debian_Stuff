import time
import paho.mqtt.client as paho
import csv
import json
from datetime import datetime
import urllib3


broker="localhost"
filename="/root/TempStats"

DS1_SINGLE_NAME="DS18B20-SINGLE"
DS1_AND_AM_NAME="DS18B20"
DS1_ID="3C01A816BC7E"
DS_AM_ID="051671A5C7FF"

DS2_1_NAME="DS18B20-1"
DS2_1_ID="3C01A8168C9A"

DS2_2_NAME="DS18B20-2"
DS2_2_ID="3C01A816B8E8"

AM_NAME="AM2301"
AM_NAME_HUMID="AM2301-HUMID"


TEMP_NA    = 255.0
TEMP_DS1   = TEMP_NA
TEMP_DS2_1 = TEMP_NA
TEMP_DS2_2 = TEMP_NA
TEMP_DS_AM = TEMP_NA
TEMP_AM    = TEMP_NA
HUMID_AM   = TEMP_NA

TIMESTAMP="default"



def thingspeak_update_all():
    global TEMP_NA
    global TEMP_DS1
    global TEMP_DS2_1
    global TEMP_DS2_2
    global TEMP_DS_AM
    global TEMP_AM
    global HUMID_AM

    if TEMP_DS2_1 == TEMP_NA and TEMP_DS2_2 == TEMP_NA and TEMP_AM == TEMP_NA and HUMID_AM == TEMP_NA and TEMP_DS_AM == TEMP_NA and TEMP_DS1 == TEMP_NA:
        return

    baseURL = 'https://api.thingspeak.com/update?api_key=02UXXAPXYAWT1FU1'
    fullURL = baseURL

    if TEMP_DS2_1 != TEMP_NA:
        fullURL = fullURL + '&field4=' + str(TEMP_DS2_1)

    if TEMP_DS2_2 != TEMP_NA:
        fullURL = fullURL + '&field3=' + str(TEMP_DS2_2)

    if TEMP_AM != TEMP_NA:
        fullURL = fullURL + '&field5=' + str(TEMP_AM)

    if HUMID_AM != TEMP_NA:
        fullURL = fullURL + '&field6=' + str(HUMID_AM)

    if TEMP_DS_AM != TEMP_NA:
        fullURL = fullURL + '&field1=' + str(TEMP_DS_AM)

    if TEMP_DS1 != TEMP_NA:
        fullURL = fullURL + '&field2=' + str(TEMP_DS1)

    print(fullURL)
    try:
        thingspeak = urllib3.PoolManager()
        f = thingspeak.request('GET', fullURL)
        f.read()
        f.close()
    except thingspeak.exceptions.ConnectTimeoutError:
        print( "ConnectTimeoutError" )
    except thingspeak.exceptions.ConnectionError:
        print( "ConnectionError" )
    except thingspeak.exceptions.NewConnectionError:
        print( "NewConnectionError" )


def thingspeak_update(sensor, value):
    if value == TEMP_NA:
        return

    baseURL = 'https://api.thingspeak.com/update?api_key=02UXXAPXYAWT1FU1&field'
    fieldNo = 0
    if sensor == DS2_1_NAME:
        fieldNo = 4
    elif sensor == DS2_2_NAME:
        fieldNo = 3
    elif sensor == AM_NAME:
        fieldNo = 5
    elif sensor == AM_NAME_HUMID:
        fieldNo = 6
    elif sensor == DS1_AND_AM_NAME:
        fieldNo = 1
    elif sensor == DS1_SINGLE_NAME:
        fieldNo = 2
    else:
        return

    fullURL = baseURL + str(fieldNo) + '=' + str(value)
    print(fullURL)
    thingspeak = urllib3.PoolManager()
    f = thingspeak.request('GET', fullURL)
    f.read()
    f.close()

#GET https://api.thingspeak.com/update?api_key=02UXXAPXYAWT1FU1&field1=0


def process_measurement(message):
    global TEMP_NA
    global TEMP_DS1
    global TEMP_DS2_1
    global TEMP_DS2_2
    global TEMP_DS_AM
    global TEMP_AM
    global HUMID_AM

    json_dict = json.loads(message)
    for key in json_dict:
        if key == DS2_1_NAME:
            TEMP_DS2_1 = json_dict[key]["Temperature"]
#            thingspeak_update(DS2_1_NAME, TEMP_DS2_1)
        elif key == DS2_2_NAME:
            TEMP_DS2_2 = json_dict[key]["Temperature"]
#            thingspeak_update(DS2_2_NAME, TEMP_DS2_2)
        elif key == AM_NAME:
            TEMP_AM = json_dict[key]["Temperature"]
#            thingspeak_update(AM_NAME, TEMP_AM)
            HUMID_AM = json_dict[key]["Humidity"]
#            thingspeak_update(AM_NAME_HUMID, HUMID_AM)
        elif key == DS1_AND_AM_NAME:
            if json_dict[key]["Id"] == DS1_ID:
                TEMP_DS1 = json_dict[key]["Temperature"]
#                thingspeak_update(DS1_SINGLE_NAME, TEMP_DS1)
            elif json_dict[key]["Id"] == DS_AM_ID:
                TEMP_DS_AM = json_dict[key]["Temperature"]
#                thingspeak_update(DS1_AND_AM_NAME, TEMP_DS_AM)


#define callback
def on_message(client, userdata, message):
    time.sleep(1)
    process_measurement(str(message.payload.decode("utf-8")))



client= paho.Client("orangePi-Thingspeak")
#create client object client1.on_publish = on_publish #assign function to callback client1.connect(broker,port)
#establish connection client1.publish("house/bulb1","on")
######Bind function to callback
client.on_message=on_message
#####
print("connecting to broker ",broker)
client.connect(broker)#connect
client.loop_start() #start loop to process received messages
print("subscribing ")
client.subscribe("tele/DUAL1_27DA80/SENSOR")
client.subscribe("tele/onlyDS1_EA4D15/SENSOR")
client.subscribe("tele/onlyDS2_1659BF/SENSOR")

while True:
    time.sleep(300)
    thingspeak_update_all()

client.disconnect() #disconnect
client.loop_stop() #stop loop
