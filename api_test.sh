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
    [[ $output == *"Invalid number of parameters. (given 0, expected 1)"* ]]
}

@test "testHiddenInvalidArgument" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run hidden orange <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid parameter. Must be either 'true' or 'false' but got: orange"* ]]
}

@test "testTypesKanji" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run types kanji <<< ""
    (( status == 0 ))
    [[ $output == "&types=kanji" ]]
}

@test "testTypesAll" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run types radical kanji vocabulary <<< ""
    (( status == 0 ))
    [[ $output == "&types=radical,kanji,vocabulary" ]]
}

@test "testTypesTooManyArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run types kanji radical radical radical <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid number of parameters. (given 4, expected [1,3])"* ]]
}

@test "testTypesNoArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run types <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid number of parameters. (given 0, expected [1,3])"* ]]
}

@test "testTypesInvalidArgument" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run types language <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid parameter. (given language, expected [radical | kanji | vocabulary])"* ]]
}

@test "testLevels3-10" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run levels {3..10} <<< ""
    (( status == 0 ))
    [[ $output == "&levels=3,4,5,6,7,8,9,10" ]]
}

@test "testLevelsAll" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run levels {1..60} <<< ""
    (( status == 0 ))
    [[ $output == "" ]]
}

@test "testLevelsTooManyArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run levels {1..74} <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid number of parameters. (given 74, expected [1, 60])"* ]]
}

@test "testLevelsNoArguments" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run levels <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid number of parameters. (given 0, expected [1, 60])"* ]]
}

@test "testLevelsInvalidArgument" {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run levels hair <<< ""
    (( status == 1 ))
    [[ $output == *"Invalid parameter. (given hair, expected [1, 60])"* ]]
}

@test "A skipped test" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run echo skipped
    (( status == 0 ))
    [[ $output == "skipped" ]]
}
