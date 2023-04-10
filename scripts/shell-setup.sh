#!/usr/bin/env sh
SHELL=$(basename $SHELL)
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${SCRIPTPATH}/generated/autocomplete.${SHELL} 2>/dev/null || echo "> No autocomplete script for ${SHELL}"
alias vfd="make -f ${SCRIPTPATH}/../Makefile prepare-exec && ${SCRIPTPATH}/../target/release/vfd"