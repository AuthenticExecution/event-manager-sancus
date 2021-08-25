#!/bin/bash

set -e

test $PORT
DEVICE=/dev/RIOT
UART_DEVICE=/dev/UART

LOG_FILE=sancus.log

echo PORT: $PORT
rm -f $LOG_FILE

reactive-uart2ip -l error -p $PORT -d $UART_DEVICE &
sancus-loader -device $DEVICE reactive.elf
screen -L -Logfile $LOG_FILE -dmS sancus $DEVICE 57600

echo "Binary loaded successfully. Printing logs"
sleep 1
tail -f $LOG_FILE
