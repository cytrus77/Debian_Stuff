import sys
from time import sleep
import urllib2

a = 'offline'
baseURL = 'http://api.thingspeak.com/update?api_key=Y5LXNXVKM4NEAZKE&field1='

while(1):
    print a
    f = urllib2.urlopen(baseURL +str(a))
    f.read()
    f.close()
    sleep(5)
    a = 'online'
print "Program has ended"
