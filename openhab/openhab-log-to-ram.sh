#!/bin/sh
#
############### Reduce SD/eMMC disk writes #######
#Send systemd journal to ram instead of disk. Deleting file will return all defaults.
sudo sed -i -e 's/#Storage=auto/Storage=volatile/g' /etc/systemd/journald.conf
#create a tmp folder in ram to redirect log files there.
sudo sh -ce "echo 'tmpfs /tmp tmpfs defaults,nosuid,nodev,noatime,size=100m 0 0' >> /etc/fstab"
sudo sed -i -e 's/exit 0/#exit 0/g' /etc/rc.local
sudo sh -ce "echo 'chown openhab:openhab /tmp/' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmp/events.log /var/log/openhab2/events.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmp/openhab.log /var/log/openhab2/openhab.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmp/syslog /var/log/syslog' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmp/daemon.log /var/log/daemon.log' >> /etc/rc.local"
sudo sh -ce "echo 'ln -sf /tmp/auth.log /var/log/auth.log' >> /etc/rc.local"
sudo sh -ce "echo 'exit 0' >> /etc/rc.local"
#redirect the ntpdrift file
sudo sed -i -e 's#driftfile /var/lib/ntp/ntp.drift#driftfile /tmp/ntp.drift#g' /etc/ntp.conf

#New method of redirecting Opehabs logs
#New method of redirecting Opehabs logs
sudo sed -i -e 's#log4j2.appender.event.fileName = ${openhab.logdir}/events.log#log4j2.appender.event.fileName = /tmp/events.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
sudo sed -i -e 's#log4j2.appender.out.fileName = ${openhab.logdir}/openhab.log#log4j2.appender.out.fileName = /tmp/openhab.log#g' /var/lib/openhab2/etc/org.ops4j.pax.logging.cfg
#List of files still doing writes
#/run/samba/msg.lock/ (multiple files)
#/run/samba/smbXsrv_client_global.tdb
#/var/cache/samba/browse.dat
# /var/lib/openhab2/config/org/eclipse/smarthome/storage/json.config //this file holds the configuration for the next few files...
#/var/lib/openhab2/jsondb/org.eclipse.smarthome.config.discovery.DiscoveryResult.json
#/var/lib/openhab2/jsondb/backup/ (multiple files)
#/var/lib/mosquitto/ (mosquitto.db and mosquitto.db.new) can be solved by editing /etc/mosquitto/mosquitto.conf and turn off persistence.
