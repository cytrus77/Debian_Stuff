import OPi.GPIO as GPIO
from time import sleep          # this lets us have a time delay
from datetime import datetime
import os, time
import email, smtplib, ssl

from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText



def sendEmail(fileList):
    subject = "[LoginLAB] Otwarto drzwi"
    body = "Otwarto drzwi"
    sender_email = "monit@icytrus.pl"
    receiver_email = "cytrus77@gmail.com"
    #password = input("Type your password and press enter:")
    password = "soAiOEG8"

    # Create a multipart message and set headers
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = subject
    message["Bcc"] = receiver_email  # Recommended for mass emails

    # Add body to email
    message.attach(MIMEText(body, "plain"))

    for filename in fileList:
        # Open file in binary mode
        with open(filename, "rb") as attachment:
            # Add file as application/octet-stream
            # Email client can usually download this automatically as attachment
            part = MIMEBase("application", "octet-stream")
            part.set_payload(attachment.read())
            # Encode file in ASCII characters to send by email
            encoders.encode_base64(part)
            # Add header as key/value pair to attachment part
            part.add_header(
                "Content-Disposition",
                f"attachment; filename= {filename}",
            )
            # Add attachment to message and convert message to string
            message.attach(part)

    text = message.as_string()

    # Log in to server using secure context and send email
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("bronek.hostinghouse.pl", 465, context=context) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, text)


def getCamera1Snap():
    filename = "cam1_" + time.strftime("%Y%m%d-%H%M%S") +".jpg"
    cmd = "ffmpeg -rtsp_transport tcp -y -i \"rtsp://192.168.21.201:554/ch01.264\" -vframes 1 " + filename
    os.system(cmd)
    return filename


def getCamera2Snap():
    filename = "cam2_" + time.strftime("%Y%m%d-%H%M%S") +".jpg"
    cmd = "ffmpeg -rtsp_transport tcp -y -i \"rtsp://192.168.21.202:554/ch01.264\" -vframes 1 " + filename
    os.system(cmd)
    return filename


def getCamera3Snap():
    filename = "cam3_" + time.strftime("%Y%m%d-%H%M%S") +".jpg"
    cmd = "ffmpeg -rtsp_transport tcp -y -i \"rtsp://192.168.21.203:554/mpeg4?username=admin&password=98E822D9E3A6E1A50D092BF1914F6F45\" -vframes 1 " + filename
    os.system(cmd)
    return filename



GPIO.setboard(GPIO.ZERO)
GPIO.setmode(GPIO.SOC)          # set up SOC numbering

DOOR = GPIO.PA+12               # DOOR sensor is on PA12
GPIO.setup(DOOR, GPIO.IN)       # set PA12 as an input

LastDoor = False
GetSnap = False
NoOfSnaps = 3

try:
    while True:                 # this will carry on until you hit CTRL+C
        if GPIO.input(DOOR):      # if DOOR pin == 1
#            print("DOOR OPEN")
            if LastDoor == False:
                LastDoor = True
                GetSnap  = True
        else:
#            print("DOOR CLOSED")
            LastDoor = False

        if GetSnap == True:
            fileList = []
            print("Getting snapshot")
            sleep(3)
            getCamera2Snap()
            getCamera2Snap()
            getCamera3Snap()
#            for x in range(NoOfSnaps):
#                fileList.append(getCameraSnap())
            sendEmail(fileList)
            GetSnap = False
        sleep(1)


finally:                        # this block will run no matter how the try block exits
    print("Finally")
    GPIO.cleanup()              # clean up after yourself
