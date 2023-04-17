#!/bin/fish
# Current shell
set SCRIPT_PATH (dirname (status --current-filename))
set PROJECT_PATH (dirname $SCRIPT_PATH/../)

set -x PATH $PATH $PROJECT_PATH/bin
source $SCRIPT_PATH/generated/autocomplete.fish