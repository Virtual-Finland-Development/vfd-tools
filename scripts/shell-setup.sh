SHELL=$(basename $SHELL)
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

alias vfd="${SCRIPT_PATH}/vfd.sh"
source ${SCRIPT_PATH}/generated/autocomplete.${SHELL} 2>/dev/null || echo "> No autocomplete script for ${SHELL}"
