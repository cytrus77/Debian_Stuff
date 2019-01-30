#!/bin/bash

echo "Seting timezone for Poland ..."
unlink /etc/localtime
ln -s /usr/share/zoneinfo/Poland /etc/localtime
echo "Done."
