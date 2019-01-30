#!/bin/bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9
apt-add-repository 'deb http://repos.azulsystems.com/debian stable main'
apt update
apt install -y zulu-embedded-8
