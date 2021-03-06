#!/bin/sh

SCRIPTNAME="hamachiOpt"
SERVICENAME="logmein-hamachi.service"
IDFILEPATH="/var/lib/logmein-hamachi"
LOGGINGNAME="Hamachi LogMeIn"
#HAMACHIURL="https://www.vpn.net/installers/logmein-hamachi_2.1.0.198-1_armhf.deb"
HAMACHIURL="https://www.vpn.net/installers/logmein-hamachi_2.1.0.203-1_armhf.deb"
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

do_uninstall()
{
        echo "Stopping $LOGGINGNAME service"
        systemctl stop $SERVICENAME

        echo "Uninstalling $LOGGINGNAME"
        dpkg -r logmein-hamachi

        echo "Done"
        return 0
}

do_networkfix()
{
        echo "Delete old default gateway"
        route del default

        echo "Setting new default gateway - $newIp"
        route add default gw $newIp

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
  uninstall)
        do_uninstall
        case "$?" in
                0) echo "All OK" ;;
                1|*) echo "Some problem occurred !" ;;
        esac
        ;;
  fixnetwork)
        newIp=$2
        do_networkfix
        case "$?" in
                0) echo "All OK" ;;
                1|*) echo "Some problem occurred !" ;;
        esac
        ;;


  *)
	echo "Usage: $SCRIPTNAME {install|resetid|uninstall|fixnetwork}" >&2
	exit 3
	;;
esac

:

