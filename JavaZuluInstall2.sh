#!/bin/bash

dpkg --add-architecture armhf
apt install -y nano build-essential libc6:armhf software-properties-common
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main'
apt install zulu-embedded:armhf
