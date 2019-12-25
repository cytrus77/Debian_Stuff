#!/bin/bash

echo "Hamachi daily restart"
systemctl restart logmein-hamachi.service
sleep 10
hamachi logout
sleep 5
hamachi login
echo "Hamachi restart done"
