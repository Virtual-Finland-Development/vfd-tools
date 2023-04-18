#!/usr/bin/env bash
current_shell=$(ps -p $$ -o comm=)
current_shell_short=$(basename ${current_shell})

script_path=${BASH_SOURCE[0]}
if [ "${current_shell_short}" = "zsh" ]; then
    script_path=${0:A}
fi

PROJECT_PATH=$(dirname "$(dirname "$(readlink -f "${script_path}")")")
source ${PROJECT_PATH}/scripts/generated/autocomplete.${current_shell_short} 2>/dev/null || echo "> No autocomplete script for ${current_shell_short}"

function vfd() {
    make --silent --directory ${PROJECT_PATH} prepare-exec
    VFD_TOOLS_CONFIGS_PATH=${PROJECT_PATH} ${PROJECT_PATH}/bin/vfd $@
}