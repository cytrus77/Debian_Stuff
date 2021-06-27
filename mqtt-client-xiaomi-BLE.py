import time
import paho.mqtt.client as paho
import csv
import json
from datetime import datetime


broker="localhost"
filename="/tmp/XiaomiBLE"

Sensor1Topic="4c:65:a8:d9:3e:2a"
Sensor2Topic="58:2d:34:3a:39:6b"
Sensor3Topic="4c:65:a8:d4:2e:b4"

TIMESTAMP="default"


def store_to_csv(topic, value):
    with open(filename, mode='a') as csv_file:
        dateTimeObj = datetime.now()
        TIMESTAMP = dateTimeObj.strftime("%Y-%m-%d %H:%M:%S")
        csv_writer = csv.writer(csv_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow([TIMESTAMP, topic, value])


#define callback
def on_message(client, userdata, message):
    store_to_csv(message.topic, message.payload)




dateTimeObj = datetime.now()
TIMESTAMP = dateTimeObj.strftime("%Y_%m_%d_%H%M%S")
filename = filename + TIMESTAMP + ".csv"

with open(filename, mode='w') as csv_file:
    csv_writer = csv.writer(csv_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    csv_writer.writerow(["timestamp", "topic", "value"])

client= paho.Client("RPi-internal-X")
#create client object client1.on_publish = on_publish #assign function to callback client1.connect(broker,port)
#establish connection client1.publish("house/bulb1","on")
######Bind function to callback
client.on_message=on_message
#####
print("connecting to broker ",broker)
client.connect(broker)#connect
client.loop_start() #start loop to process received messages
print("subscribing ")

client.subscribe(Sensor1Topic + "/temperature")
client.subscribe(Sensor1Topic + "/humidity")
client.subscribe(Sensor1Topic + "/battery")

client.subscribe(Sensor2Topic + "/temperature")
client.subscribe(Sensor2Topic + "/humidity")
client.subscribe(Sensor2Topic + "/battery")

client.subscribe(Sensor3Topic + "/temperature")
client.subscribe(Sensor3Topic + "/humidity")
client.subscribe(Sensor3Topic + "/battery")

while True:
    time.sleep(5)

client.disconnect() #disconnect
client.loop_stop() #stop loop
