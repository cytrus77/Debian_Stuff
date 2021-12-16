#!/bin/bash

echo "QNAP waking up..."
etherwake 24:5E:BE:37:59:AC
sleep 0.5
etherwake 24:5E:BE:37:59:AC
echo "It's done"
