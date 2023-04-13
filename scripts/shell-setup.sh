#!/usr/bin/env sh
SHELL=$(basename $SHELL)
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPT_PATH}/generated/autocomplete.${SHELL} 2>/dev/null || echo "> No autocomplete script for ${SHELL}"

function vfd() {
    make -f ${SCRIPT_PATH}/../Makefile prepare-exec
    ${SCRIPT_PATH}/../bin/vfd $@
}