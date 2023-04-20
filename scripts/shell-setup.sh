#!/usr/bin/env bash
current_shell=$(ps -p $$ -o comm= | tr -d '-')

script_path=${BASH_SOURCE[0]}
if [ "${current_shell}" = "zsh" ]; then
    script_path=${0:A}
fi

PROJECT_PATH=$(dirname "$(dirname "$(readlink -f "${script_path}")")")
source ${PROJECT_PATH}/scripts/generated/autocomplete.${current_shell} 2>/dev/null || echo "> No autocomplete script for ${current_shell}"

function vfd() {
    make --silent --directory ${PROJECT_PATH} install
    VFD_TOOLS_CONFIGS_PATH=${PROJECT_PATH} ${PROJECT_PATH}/bin/vfd $@
}