#!/usr/bin/sh
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Current shell
SHELL=$(basename $SHELL)

if [ ! -f ${SCRIPTPATH}/autocompletes/vfd.${SHELL} ]; then
    echo "No autocomplete script for ${SHELL}"
    exit 1
fi

source ${SCRIPTPATH}/autocompletes/vfd.${SHELL}