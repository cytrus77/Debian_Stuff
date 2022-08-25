import OPi.GPIO as GPIO
from time import sleep          # this lets us have a time delay
from datetime import datetime
import os


GPIO.setboard(GPIO.ZERO)
GPIO.setmode(GPIO.SOC)          # set up SOC numbering

DOOR = GPIO.PA+12               # DOOR sensor is on PA12
GPIO.setup(DOOR, GPIO.IN)       # set PA12 as an input

LastDoor = False
GetSnap = False

try:
    while True:                 # this will carry on until you hit CTRL+C
        if GPIO.input(DOOR):      # if DOOR pin == 1
            print("DOOR OPEN")
            if LastDoor == False:
                LastDoor = True
                GetSnap  = True
        else:
            print("DOOR CLOSED")
            LastDoor = False

        if GetSnap == True:
            dateTimeObj = datetime.now()
            print("Getting snapshot")
            print(dateTimeObj)
            cmd = "ffmpeg -rtsp_transport tcp -y -i \"rtsp://192.168.21.203:554/mpeg4?username=admin&password=98E822D9E3A6E1A50D092BF1914F6F45\" -vframes 1 cam3_$(date \"+%Y.%m.%d-%H.%M.%S\").jpg"
            os.system(cmd)
            GetSnap = False
            sleep(10)
        sleep(1)


finally:                        # this block will run no matter how the try block exits
    print("Finally")
    GPIO.cleanup()              # clean up after yourself
