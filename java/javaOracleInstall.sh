#!/bin/bash

apt update
apt install -y wget libasound2 libasound2-data

wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.bell-sw.com/java/13.0.1/bellsoft-jre13.0.1-linux-arm32-vfp-hflt.deb
dpkg -i bellsoft-jre13.0.1-linux-arm32-vfp-hflt.deb
apt-get install -f
dpkg -i bellsoft-jre13.0.1-linux-arm32-vfp-hflt.deb

update-alternatives --install /usr/bin/java java  /usr/lib/jvm/jdk-13.0.1/bin/java 2
update-alternatives --config java

update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-13.0.1/bin/jar 2
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-13.0.1/bin/javac 2
update-alternatives --set jar /usr/lib/jvm/jdk-13.0.1/bin/jar
update-alternatives --set javac /usr/lib/jvm/jdk-13.0.1/bin/javac

java -version

export J2SDKDIR=/usr/lib/jvm/jdk-13.0.1 >> /etc/profile.d/jdk.sh
export J2REDIR=/usr/lib/jvm/jdk-13.0.1 >> /etc/profile.d/jdk.sh
export PATH=$PATH:/usr/lib/jvm/jdk-13.0.1/bin:/usr/lib/jvm/jdk-13.0.1/db/bin >> /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-13.0.1 >> /etc/profile.d/jdk.sh
export DERBY_HOME=/usr/lib/jvm/jdk-13.0.1/db >> /etc/profile.d/jdk.sh

source /etc/profile.d/jdk.sh
