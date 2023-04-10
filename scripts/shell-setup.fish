#!/bin/fish
# Current shell
set SCRIPTPATH (dirname (status --current-filename))

source $SCRIPTPATH/generated/autocomplete.fish
function vfd
    make -f $SCRIPTPATH/../Makefile prepare-exec
    $SCRIPTPATH/../target/release/vfd $argv
end