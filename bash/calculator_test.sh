#!/bin/bash

assert_equals() {
    local operation=$2
    local operand_a=$3
    local operand_b=$4
    local expected=$1
    local actual=$(./calculator.sh $operation $operand_a $operand_b)

    if [[ "$actual" == "$expected" ]]
    then
        echo "PASSED :: $operation ($operand_a, $operand_b)"
    else
        echo "FAILED :: $operation ($operand_a $operand_b) -> $actual != $expected"
    fi
}

assert_equals 1 sum 0 1
assert_equals 1 sum 1 0
assert_equals 5 sum 2 3
assert_equals 5 sum 3 2

assert_equals -1 sub 0 1
assert_equals 1 sub 1 0
assert_equals -1 sub 2 3
assert_equals 1 sub 3 2

assert_equals 0 mul 0 1
assert_equals 0 mul 1 0
assert_equals 6 mul 2 3
assert_equals 6 mul 3 2

assert_equals 0 div 0 1
assert_equals 0 div 2 3
assert_equals 1 div 3 2
assert_equals "You shall not divide by zero" div 1 0

assert_equals "invalid-operation is not a valid operation" invalid-operation 8 9
assert_equals "Both operands should be integers" invalid-a-operand foo 1
assert_equals "Both operands should be integers" invalid-b-operand 1 foo
