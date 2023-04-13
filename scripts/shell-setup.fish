#!/bin/fish
# Current shell
set SCRIPT_PATH (dirname (status --current-filename))

source $SCRIPT_PATH/generated/autocomplete.fish
function vfd
    make -f $SCRIPT_PATH/../Makefile prepare-exec
    $SCRIPT_PATH/../bin/vfd $argv
end