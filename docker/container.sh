#!/usr/bin/env bash

IMAGE_TAG="calculator-microservice"
CONTAINER_NAME="calculator-microservice"
CONTAINER_HOST_PORT=8081

build_docker_image () {
    docker build --tag "$IMAGE_TAG" .
}

start_docker_container() {
    if [[ "$(get_docker_container_status)" == *"is running"* ]]
    then
        echo "$CONTAINER_NAME is running already."
    else
        docker run --detach -p "$CONTAINER_HOST_PORT":8080 --name "$CONTAINER_NAME" "$IMAGE_TAG"
    fi
}

stop_docker_container() {
    if [[ "$(get_docker_container_status)" == *"is running"* ]]
    then
        docker stop "$CONTAINER_NAME"
        docker rm "$CONTAINER_NAME"
    else
        echo "$CONTAINER_NAME cannot be stopped because it's not running yet."
    fi
}

get_docker_container_status() {
    number_of_containers_running=$(docker ps --filter name="$CONTAINER_NAME" | wc -l)

    if [[ $number_of_containers_running -eq 2 ]]
    then
        echo "$CONTAINER_NAME is running on port $CONTAINER_HOST_PORT"
    else
        echo "$CONTAINER_NAME is not running"
    fi
}

case $1 in
    build)
        build_docker_image
        ;;
    start|stop)
        "$1"_docker_container
        ;;
    status)
        get_docker_container_status
        ;;
    *)
        echo "Invalid action. It should be build, start, stop or status."
        ;;
esac
