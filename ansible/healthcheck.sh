#!/usr/bin/env bash

APP_BINARY_NAME="calculator-microservice"
PID=$(ps aux | grep $APP_BINARY_NAME | grep -v grep | awk '{print $2}')

if [ "$(echo $PID | wc -w)" -eq 1 ]
then
    echo "$APP_BINARY_NAME is running (PID $PID)"
else
    echo "$APP_BINARY_NAME is not running"
fi
