#!/bin/bash

set -e

test $PORT
test $DEVICE
test $UART_DEVICE

LOG_FILE=sancus.log

echo DEV: $DEVICE UART: $UART_DEVICE PORT: $PORT
rm -f $LOG_FILE

reactive-uart2ip -l error -p $PORT -d $UART_DEVICE &
sancus-loader -device $DEVICE reactive.elf
screen -L -Logfile $LOG_FILE -dmS sancus $DEVICE 57600

echo "Binary loaded successfully. Printing logs"
sleep 1
tail -f $LOG_FILE
