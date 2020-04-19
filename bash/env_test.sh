#!/bin/bash

test_it_works () {
    rm -rf conf/

    local output=$(./env.sh)
    local output=$(echo "$(find -type f -name 'env_data.txt' -exec sh -c 'cat {} | wc -l' \;)")

    if [[ "$amount_of_lines_of_file" -ne 0 ]]
    then
        echo "[PASSED] :: It works"
    else
        echo "[FAILED] :: It works -> File is empty"
    fi

    rm -rf conf/
}

test_it_works
