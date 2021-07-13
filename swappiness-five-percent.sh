#!/bin/bash

echo "Swappiness before:"
cat /proc/sys/vm/swappiness

echo "Changing to 5%"
sysctl vm.swappiness=5
