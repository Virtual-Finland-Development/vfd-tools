#!/bin/fish
set PROJECT_PATH (dirname (readlink -f (dirname (status --current-filename))))

source $PROJECT_PATH/scripts/generated/autocomplete.fish
function vfd
    make --silent --directory $PROJECT_PATH prepare-exec
    set -g -x VFD_TOOLS_CONFIGS_PATH $PROJECT_PATH
    $PROJECT_PATH/bin/vfd $argv
end