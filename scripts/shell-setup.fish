#!/bin/fish
# Current shell
set SCRIPT_PATH (dirname (status --current-filename))
set PROJECT_PATH (dirname $SCRIPT_PATH/../)

alias vfd="$SCRIPT_PATH/vfd.sh"
source $SCRIPT_PATH/generated/autocomplete.fish