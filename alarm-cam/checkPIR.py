import OPi.GPIO as GPIO
from time import sleep          # this lets us have a time delay
from datetime import datetime
import os


GPIO.setboard(GPIO.ZERO)
GPIO.setmode(GPIO.SOC)          # set up SOC numbering

PIR1 = GPIO.PA+13               # PIR sensor is on PA13
GPIO.setup(PIR1, GPIO.IN)       # set PA13 as an output (Status led of board)


try:
    while True:                 # this will carry on until you hit CTRL+C
        if GPIO.input(PIR1):      # if PIR1 pin == 1
            print("PIR1 HIGH")
            dateTimeObj = datetime.now()
            print(dateTimeObj)
            cmd = "ffmpeg -rtsp_transport tcp -y -i \"rtsp://192.168.21.203:554/mpeg4?username=admin&password=98E822D9E3A6E1A50D092BF1914F6F45\" -vframes 1 cam3_$(date \"+%Y.%m.%d-%H.%M.%S\").jpg"
            os.system(cmd)
#        else:
#            print("PIR1 LOW")
        sleep(300)


finally:                        # this block will run no matter how the try block exits
    print("Finally")
    GPIO.cleanup()              # clean up after yourself
