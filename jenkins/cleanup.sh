#!/bin/bash

if [ $(docker ps --filter name="$IMAGE" | wc -l) -eq 2 ]
then
    echo "Stopping $IMAGE container"
    docker stop $IMAGE
fi
