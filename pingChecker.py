import os
import sys
from time import sleep
import urllib2

baseURL = 'http://api.thingspeak.com/update?api_key=Y5LXNXVKM4NEAZKE'

def check_ping(name, ipaddr, field):
    response = os.system("ping -c 1 " + ipaddr + " > /dev/null")
    # and then check the response...
    if response == 0:
        value = 1
        pingstatus = "Network Active"
        print name + ' is online'
    else:
        value = 0
        pingstatus = "Network Error"
        print name + ' is OFFLINE !'

    if field != 'field9':
        fieldURL = '&' + field + '=' + str(value)
        return fieldURL

    return ''

DeviceList = [
              ['Router Brama', '192.168.16.254', 'field1'],
              ['Ogrod', '192.168.16.253', 'field2'],
              ['Puff', '192.168.16.252', 'field9'],
              ['Puff AP', '192.168.16.251', 'field9'],
              ['Sobanski', '192.168.16.250', 'field3'],
              ['Fraszczak', '192.168.16.249', 'field4'],
              ['Spitalniak', '192.168.16.248', 'field5'],
              ['Mlynski', '192.168.16.247', 'field6'],
              ['Kaczmarek', '192.168.16.246', 'field7'],
              ['Hencel', '192.168.16.245', 'field8'],
              ['Mikolajczyk', '192.168.16.244', 'field9'],
              ['Szklany', '192.168.16.243', 'field9'],
              ['Worszty AP', '192.168.16.241', 'field9']
             ]


while(1):
    sendURL = baseURL
    for device in DeviceList:
        sendURL = sendURL + check_ping(device[0], device[1], device[2])

    print sendURL
    f = urllib2.urlopen(sendURL)
    f.read()
    f.close()

    sleep(300)

print "Program has ended"
