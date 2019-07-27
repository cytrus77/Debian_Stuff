#!/bin/sh
#
# Please edit the following lines to set your preferences and then run this script.
# To run the script type 'sudo bash ./install-openhab-arm64.sh |& tee install.log' without the quotes to send a full copy of the terminal output to file.
# Type 'sudo bash ./install-openhab-arm64.sh' without the quotes to not output to file as it may fix any display errors.
#
####################### PREFERENCES #####################

#You should not login as root after this script is run. This is the username that will be created for you to logon from now on.
UserName=openhabian

#Hostname that you can use instead of an IP address. Defaults to openhabianpi as many parts of the documentation refer to links using this.
HostName=openhabianpi


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
sudo sh -ce "echo 'exit 0' >> /etc/rc.local"
#Needed so frontail can still find the files
sudo ln -sf /tmpfs/events.log /var/log/openhab2/events.log
sudo ln -sf /tmpfs/openhab.log /var/log/openhab2/openhab.log
#redirect the ntpdrift file
sudo sed -i -e 's#driftfile /var/lib/ntp/ntp.drift#driftfile /tmpfs/ntp.drift#g' /etc/ntp.conf

#New method of redirecting Opehabs logs
sudo sed -i -e 's#log4j2.appender.event.fileName = ${openhab.logdir}/events.log#log4j2.appender.event.fileName = /tmpfs/events.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
sudo sed -i -e 's#log4j2.appender.out.fileName = ${openhab.logdir}/openhab.log#log4j2.appender.out.fileName = /tmpfs/openhab.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
