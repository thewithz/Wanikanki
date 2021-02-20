#!/bin/bash

set -e -E -o pipefail
trap 'error "linenumber: $LINENO"' ERR

# a library of functions for interacting with wanikani's api

API_ROOT="https://api.wanikani.com/v2"

HEADERS=(
)

wanikani::subjects() {
    echo "$API_ROOT/subjects?"
}

wanikani::assignments() {
    echo "$API_ROOT/assignments?"
}

# Return subjects of the specified types.
# $@: radical | kanji | vocabulary
types() {
    (( "$#" >= 1 && "$#" <= 3)) ||
        error "Invalid number of parameters. (given $#, expected [1,3])"
    for arg in "$@"
    do
        case "$arg" in
            radical | kanji | vocabulary)
                ;;
            *)
                error "Invalid parameter. (given $arg, expected [radical | kanji | vocabulary])"
                ;;
        esac
    done
    # replace spaces with commas
    values=$(tr -s '[:blank:]' ',' <<< "$*")
    echo "$(cat -)&${FUNCNAME[0]}=$values"
}

# Only objects where the associated subject level matches one of
# the array values are returned. Valid values range from 1 to 60.
# $@: arbitrary length array of integers. Max length is 60 (there's 60 levels)
levels() {
    (( "$#" >= 1 && "$#" <= 60 )) ||
        error "Invalid number of parameters. (given $#, expected [1, 60])"
    for arg in "$@"
    do
        (( "$arg" >= 1 && "$arg" <= 60 )) ||
            error "Invalid parameter. (given $arg, expected [1, 60])"
    done
    # if requesting all 60 levels, don't add to query because getting all
    # levels is default behavior
    # echo "$(cat -)" causes a shellcheck error in this case so
    # use cat <&0 to redirect stdin to stdout instead
    (( "$#" == 60 )) && cat <&0 && return 0
    # replace spaces with commas
    values=$(tr -s '[:blank:]' ',' <<< "$*")
    echo "$(cat -)&${FUNCNAME[0]}=$values"
}

# Return objects with a matching value in the hidden attribute
# $1: true | false
hidden() {
    (( "$#" == 1 )) ||
        error "Invalid number of parameters. (given $#, expected 1)"
    [[ "$1" == "true" || "$1" == "false" ]] ||
        error "Invalid parameter. Must be either 'true' or 'false' but got: $*"
    echo "$(cat -)&${FUNCNAME[0]}=$1"
}

# Initiates API call
# $1: url from builder pattern
build() {
    (( "$#" == 1 )) ||
        error "Invalid number of parameters. (given $#, expected 1)"
    curl "$1" \
        -H "Wanikani-Revision: $(jq -r '.api_version' config.json)" \
        -H "Authorization: Bearer $(jq -r '.api_key' config.json)"
    echo $?
}

error() {
    >&2 echo -e "From function: ${FUNCNAME[1]}\n$1"
    exit 1
}

build ""
build $(wanikani::subjects | types kanji vocabulary | hidden false | levels {1..2})
