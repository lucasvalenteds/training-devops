#!/bin/bash

SOURCE_FOLDER_PATH=$1
TARGET_FOLDER_NAME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TARGET_FOLDER_PATH=$(echo "$(pwd)/backup/data/$TARGET_FOLDER_NAME")
FILE_COMPRESSED="backup.zip"

fail_if_zip_not_installed () {
    if ! [ -x "$(command -v zip)" ]
    then
        echo "The zip package should be installed. Run \`sudo apt install zip\` to install it."
        exit 1
    fi
}

fail_if_zip_not_installed

case $SOURCE_FOLDER_PATH in
    "")
        echo "Missing folder with files to be compressed"
        ;;
    *)
        zip -r $FILE_COMPRESSED $SOURCE_FOLDER_PATH
        mkdir -p $TARGET_FOLDER_PATH
        mv "./$FILE_COMPRESSED" $TARGET_FOLDER_PATH
        ;;
esac
