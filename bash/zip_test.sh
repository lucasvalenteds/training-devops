test_pass () {
    local title=$1
    echo "[PASSED] $title"
}

test_fail () {
    local title=$1
    echo "[FAILED] $title"
}

missing_source () {
    local title=$(echo "souce_folder_must_be_informed")
    local output=$(./zip.sh)

    if [[ "$output" == "Missing folder with files to be compressed" ]]
    then
        test_pass $title
    else
        test_fail $title
    fi
}

nested_content () {
    rm -rf backup/
    mkdir -p fixtures/nested
    echo "foo" > fixtures/foo.txt
    echo "bar" > fixtures/nested/bar.txt

    local expected=$(echo "adding: fixtures/foo.txt (stored 0%)")
    local expected_nested=$(echo "adding: fixtures/foo.txt (stored 0%)")

    local title=$(echo "it_works_with_nested_content")
    local output=$(./zip.sh ./fixtures)

    if [[ "$output" == *"$expected"* ]] && [[ "$output" == *"$expected_nested"* ]]
    then
        test_pass $title
    else
        test_fail $title
    fi

    rm -rf fixtures/
    rm -rf backup/
}

creates_zip_file () {
    rm -rf backup/
    mkdir -p fixtures/nested
    echo "foo" > fixtures/foo.txt
    echo "bar" > fixtures/nested/bar.txt

    local title=$(echo "it_creates_zip_file_with_source_folder_content")
    local output=$(./zip.sh ./fixtures)

    local output=$(echo "$(find -type f -name "backup.zip" -exec unzip -l {} \;)")
    local expected=$(echo "fixtures/foo.txt")
    local expected_nested=$(echo "fixtures/nested/bar.txt")
    local expected_files=$(echo "4 files")

    if [[ "$output" == *"$expected"* ]] && [[ "$output" == *"$expected_nested"* ]] && [[ "$output" == *"$expected_files"* ]]
    then
        test_pass $title
    else
        test_fail $title
    fi

    rm -rf fixtures/
    rm -rf backup/
}

missing_source
nested_content
creates_zip_file
