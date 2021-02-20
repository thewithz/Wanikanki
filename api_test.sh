#!/bin/bash

source wanikani_api.sh

# unit tests

@test "testHiddenTrue" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden true <<< ""
    (( status == 0 ))
    [[ $output == "&hidden=true" ]]
}

@test "testHiddenFalse" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden false <<< ""
    (( status == 0 ))
    [[ $output == "&hidden=false" ]]
}

@test "testHiddenTooManyArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden true false true <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid number of parameters. (given 3, expected 1)"* ]]
}

@test "testHiddenNoArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden <<< ""
    (( status == 1 ))
    echo $output
    [[ $output == *"Invalid number of parameters. (given 0, expected 1)"* ]]
}

@test "testHiddenInvalidArgument" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden orange <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid parameter. Must be either 'true' or 'false' but got: orange"* ]]
}

@test "A skipped test" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run echo skipped
    (( status == 0 ))
    [[ $output == "skipped" ]]
}
