#!/bin/bash

set -e

test $PORT
test $DEVICE

DEVICE_NET=$(echo $DEVICE | perl -pe 's/(\d+)(?!.*\d+)/$1+1/e')

echo DEV: $DEVICE NET: $DEVICE_NET PORT: $PORT

reactive-uart2ip -l info -p $PORT -d $DEVICE_NET > /dev/null 2>&1 &
sancus-loader -device $DEVICE reactive.elf
screen -L -Logfile sancus.log -dmS sancus $DEVICE 57600

echo "Binary loaded successfully. Printing logs"
sleep 1
tail -f sancus.log
