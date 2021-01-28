#!/bin/sh
#
# Please edit the following lines to set your preferences and then run this script.
# To run the script type 'sudo bash ./install-openhab-arm64.sh |& tee install.log' without the quotes to send a full copy of the terminal output to file.
# Type 'sudo bash ./install-openhab-arm64.sh' without the quotes to not output to file as it may fix any display errors.
#
####################### PREFERENCES #####################
# Enter path to where the latest Zulu 32bit+HF JVM file can be downloaded from. This one has been tested to work last time I ran the script.

#Name of just the file from the link above without the filename extension.

#You should not login as root after this script is run. This is the username that will be created for you to logon from now on.
UserName=openhabian

#Hostname that you can use instead of an IP address. Defaults to openhabianpi as many parts of the documentation refer to links using this.
HostName=openhabianpi

#Install ffmpeg for IpCameras.

#Install openhabian which will not be used to install openhab2, but can be run to access any features it contains.

#This is very handy to watch your log files through a browser.

#This options sends the openhab log files and some other files to a RAM based location that will wipe the files clean on a reboot
#This is done to reduce corrupt flash storage when the power fails in the middle of a SD card write.

# Specify when the Blue LED should flash, some options are 'none','sd','emmc','heartbeat'

#Install the addon shield RTC to keep the time accurate when net connection goes down
#Leave this as false unless you know what this is. It is an optional extra purchase.

#Options for a MQTT broker. If you dont want it to install change the next line to false
################## Do NOT change any lines below here, all options that may need to be changed should be above this line ###################
#Send systemd journal to ram instead of disk. Deleting file will return all defaults.
sudo sed -i -e 's/#Storage=auto/Storage=volatile/g' /etc/systemd/journald.conf
#create a tmp folder in ram to redirect log files there.
sudo sh -ce "echo 'tmpfs /tmpfs tmpfs defaults,nosuid,nodev,noatime,size=100m 0 0' >> /etc/fstab"
sudo sed -i -e 's/exit 0/#exit 0/g' /etc/rc.local
sudo sh -ce "echo 'chown openhab:openhab /tmpfs/' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmpfs/events.log /var/log/openhab2/events.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmpfs/openhab.log /var/log/openhab2/openhab.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmpfs/syslog /var/log/syslog' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmpfs/daemon.log /var/log/daemon.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmpfs/auth.log /var/log/auth.log' >> /etc/rc.local"
#change blue LED to flash on SD access, need to give option on what flash is used...
sudo sh -ce "echo 'echo $BlueLEDflashesOn >/sys/class/leds/blue\:heartbeat/trigger' >> /etc/rc.local"
sudo sh -ce "echo 'exit 0' >> /etc/rc.local"
#Needed so frontail can still find the files
sudo ln -sf /tmpfs/events.log /var/log/openhab2/events.log
sudo ln -sf /tmpfs/openhab.log /var/log/openhab2/openhab.log

#New method of redirecting Opehabs logs
sudo sed -i -e 's#log4j2.appender.event.fileName = ${openhab.logdir}/events.log#log4j2.appender.event.fileName = /tmpfs/events.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
sudo sed -i -e 's#log4j2.appender.out.fileName = ${openhab.logdir}/openhab.log#log4j2.appender.out.fileName = /tmpfs/openhab.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
#List of files still doing writes
#/run/samba/msg.lock/ (multiple files)
#/run/samba/smbXsrv_client_global.tdb
#/var/cache/samba/browse.dat
# /var/lib/openhab2/config/org/eclipse/smarthome/storage/json.config //this file holds the configuration for the next few files...
#/var/lib/openhab2/jsondb/org.eclipse.smarthome.config.discovery.DiscoveryResult.json
#/var/lib/openhab2/jsondb/backup/ (multiple files)
#/var/lib/mosquitto/ (mosquitto.db and mosquitto.db.new) can be solved by editing /etc/mosquitto/mosquitto.conf and turn off persistence.


