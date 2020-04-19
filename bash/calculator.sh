#!/usr/bin/env bash

is_integer () {
    local input=$1
    local integer='^-?[0-9]+$'

    if [[ $input =~ $integer ]]
    then
        echo 0
    else
        echo 1
    fi
}

invalid_operation () {
    echo "$OPERATION is not a valid operation"
}

sum () {
    echo "$1 + $2" | bc
}

sub () {
    echo "$1 - $2" | bc
}

mul () {
    local result=$(expr $1 "*" $2)
    echo "$result"
}

div () {
    if [[ $2 -le 0 ]]
    then
        echo "You shall not divide by zero"
    else
        echo "$1 / $2" | bc
    fi
}

OPERATION=$1
OPERAND_A=$2
OPERAND_B=$3

if [[ $(is_integer $OPERAND_A) -ne 0 ]] || [[ $(is_integer $OPERAND_B) -ne 0 ]]
then
    echo "Both operands should be integers"
    exit 1;
fi

case $OPERATION in
    sum|sub|mul|div)
        $OPERATION $OPERAND_A $OPERAND_B
        ;;
    *)
        invalid_operation
        ;;
esac
