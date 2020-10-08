import time
import paho.mqtt.client as paho
import csv
import json
from datetime import datetime


broker="localhost"
filename="TempStats"

DS1_AND_AM_NAME="DS18B20"
DS1_ID="3C01A816BC7E"
DS_AM_ID="051671A5C7FF"

DS2_1_NAME="DS18B20-1"
DS2_1_ID="3C01A8168C9A"

DS2_2_NAME="DS18B20-2"
DS2_2_ID="3C01A816B8E8"

AM_NAME="AM2301"


TEMP_NA    = 255.0
TEMP_DS1   = TEMP_NA
TEMP_DS2_1 = TEMP_NA
TEMP_DS2_2 = TEMP_NA
TEMP_DS_AM = TEMP_NA
TEMP_AM    = TEMP_NA
HUMID_AM   = TEMP_NA

TIMESTAMP="default"


def store_to_csv():
    global TEMP_NA
    global TEMP_DS1
    global TEMP_DS2_1
    global TEMP_DS2_2
    global TEMP_DS_AM
    global TEMP_AM
    global HUMID_AM

    with open(filename, mode='a') as csv_file:
        dateTimeObj = datetime.now()
        TIMESTAMP = dateTimeObj.strftime("%Y-%m-%d %H:%M:%S")
        csv_writer = csv.writer(csv_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow([TIMESTAMP, TEMP_DS1, TEMP_DS2_1, TEMP_DS2_2, TEMP_DS_AM, TEMP_AM, HUMID_AM])

    TEMP_DS1   = TEMP_NA
    TEMP_DS2_1 = TEMP_NA
    TEMP_DS2_2 = TEMP_NA
    TEMP_DS_AM = TEMP_NA
    TEMP_AM    = TEMP_NA
    HUMID_AM   = TEMP_NA


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
        elif key == DS2_2_NAME:
            TEMP_DS2_2 = json_dict[key]["Temperature"]
        elif key == AM_NAME:
            TEMP_AM = json_dict[key]["Temperature"]
            HUMID_AM = json_dict[key]["Humidity"]
        elif key == DS1_AND_AM_NAME:
            if json_dict[key]["Id"] == DS1_ID:
                TEMP_DS1 = json_dict[key]["Temperature"]
            elif json_dict[key]["Id"] == DS_AM_ID:
                TEMP_DS_AM = json_dict[key]["Temperature"]


#define callback
def on_message(client, userdata, message):
    time.sleep(1)
    process_measurement(str(message.payload.decode("utf-8")))




dateTimeObj = datetime.now()
TIMESTAMP = dateTimeObj.strftime("%Y_%m_%d_%H%M%S")
filename = filename + TIMESTAMP + ".csv"

with open(filename, mode='w') as csv_file:
    csv_writer = csv.writer(csv_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    csv_writer.writerow(["Czas", "DS1", "DS2-1", "DS2-2", "DS-AM", "AM", "wilgotnosc"])

client= paho.Client("orangePi-1")
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
    store_to_csv()

client.disconnect() #disconnect
client.loop_stop() #stop loop
