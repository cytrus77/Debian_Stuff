#!/bin/bash

apt-get update
echo "Installing mosquitto..."
apt-get install -y mosquitto mosquitto-clients
