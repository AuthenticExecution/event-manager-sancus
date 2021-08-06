#!/bin/bash

set -e

test $PORT
test $DEVICE

LOG_FILE=sancus.log
DEVICE_NET=$(echo $DEVICE | perl -pe 's/(\d+)(?!.*\d+)/$1+1/e')

echo DEV: $DEVICE NET: $DEVICE_NET PORT: $PORT
rm -f $LOG_FILE

reactive-uart2ip -l error -p $PORT -d $DEVICE_NET &
sancus-loader -device $DEVICE reactive.elf
screen -L -Logfile $LOG_FILE -dmS sancus $DEVICE 57600

echo "Binary loaded successfully. Printing logs"
sleep 1
tail -f $LOG_FILE
