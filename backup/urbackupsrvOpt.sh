#!/bin/sh

SCRIPTNAME="urbackupsrvOpt"
PACKAGENAME="urbackup-server*.deb"
APTNAME="urbackup-server"
PACKAGEURL="https://hndl.urbackup.org/Server/2.1.20/urbackup-server_2.1.20_armhf.deb"
INSTALLATIONDIR="urbackup"

do_install_apt()
{
	add-apt-repository ppa:uroni/urbackup  
	apt-get update  
	apt-get install $APTNAME
	return 0
}

do_install_url()
{
	cd ..
	mkdir $INSTALLATIONDIR
	cd $INSTALLATIONDIR
	wget $PACKAGEURL
	dpkg -i $PACKAGENAME
	apt install -f
	return 0
}


case "$1" in
  installurl)
    do_install_url
    case "$?" in
		0) echo "All OK" ;;
		1|*) echo "Some problem occurred !" ;;
	esac
	;;
  installapt)
    do_install_apt
    case "$?" in
		0) echo "All OK" ;;
		1|*) echo "Some problem occurred !" ;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {installurl|installapt}" >&2
	exit 3
	;;
esac

:

