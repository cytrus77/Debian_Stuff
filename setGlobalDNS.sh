#!/bin/bash

echo 'nameserver 8.8.8.8' | tee /etc/resolv-manual.conf
echo 'nameserver 9.9.9.9' >> /etc/resolv-manual.conf

rm /etc/resolv.conf
ln -s /etc/resolv-manual.conf /etc/resolv.conf
