#!/bin/sh

SCRIPTNAME="hamachiOpt"
SERVICENAME="logmein-hamachi.service"
IDFILEPATH="/var/lib/logmein-hamachi"
LOGGINGNAME="Hamachi LogMeIn"
HAMACHIURL="https://www.vpn.net/installers/logmein-hamachi_2.1.0.189-1_armhf.deb"
INSTALLATIONDIR="hamachi"
PACKAGENAME="logmein-hamachi*.deb"

do_install()
{
	echo "Stopping $LOGGINGNAME service"
	systemctl stop $SERVICENAME
	cd ..
	mkdir $INSTALLATIONDIR
	cd $INSTALLATIONDIR
	wget $HAMACHIURL
	dpkg -i $PACKAGENAME
	return 0
}

do_reset_id()
{
	echo "Stopping $LOGGINGNAME service"
	systemctl stop $SERVICENAME

	echo "Removing $LOGGINGNAME ID file"
	rm -r $IDFILEPATH

	echo "Starting $LOGGINGNAME service"
	systemctl start $SERVICENAME

	echo "Done"
	return 0
}


case "$1" in
  install)
    do_install
    case "$?" in
		0) echo "All OK" ;;
		1|*) echo "Some problem occurred !" ;;
	esac
	;;
  resetid)
	do_reset_id
	case "$?" in
		0) echo "All OK" ;;
		1|*) echo "Some problem occurred !" ;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {install|resetid}" >&2
	exit 3
	;;
esac

:

