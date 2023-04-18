#!/usr/bin/env bash
SHELL=$(basename $SHELL)
PROJECT_PATH="$(dirname "$(dirname "$(readlink -fm "$0")")")"

source ${PROJECT_PATH}/scripts/generated/autocomplete.${SHELL} 2>/dev/null || echo "> No autocomplete script for ${SHELL}"

function vfd() {
    make --silent --directory ${PROJECT_PATH} prepare-exec
    VFD_TOOLS_CONFIGS_PATH=${PROJECT_PATH} ${PROJECT_PATH}/bin/vfd $@
}