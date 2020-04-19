#!/bin/bash

ENV_VARIABLES=$(printenv)
TARGET_FOLDER_NAME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TARGET_FOLDER_PATH=$(echo "$(pwd)/backup/conf/$TARGET_FOLDER_NAME")
TARGET_FILE_NAME=$(echo "env_data.txt")

mkdir -p $TARGET_FOLDER_PATH
echo $ENV_VARIABLES > $TARGET_FOLDER_PATH/$TARGET_FILE_NAME
