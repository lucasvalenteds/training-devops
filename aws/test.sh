#!/usr/bin/env bash

LOAD_BALANCER_URL=""
OPERATION_PATH="calc/sum"

while true
do
    operands="$(shuf -i 1-100 -n 1)/$(shuf -i 1-100 -n 1)"
    url="$LOAD_BALANCER_URL/$OPERATION_PATH/$operands"
    echo "$url"
    curl -S "$url"
done
