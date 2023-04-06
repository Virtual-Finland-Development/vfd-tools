#compdef vfd

autoload -U is-at-least

_vfd() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'--generate-autocomplete=[]:GENERATOR:(bash elvish fish powershell zsh)' \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'--workdir=[Sets the working directory]:WORKDIR: ' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_vfd_commands" \
"*::: :->vfd" \
&& ret=0
    case $state in
    (vfd)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:vfd-command-$line[1]:"
        case $line[1] in
            (up)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'--no-traefik[Skips the traefik domain routing]' \
'--no-detach[Runs the docker compose command without detaching]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(down)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'--no-traefik[Skips the traefik domain routing]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(ps)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(restart)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(git)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
":: :_vfd__git_commands" \
"*::: :->git" \
&& ret=0

    case $state in
    (git)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:vfd-git-command-$line[1]:"
        case $line[1] in
            (status)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(pull)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(push)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(commit)
_arguments "${_arguments_options[@]}" \
'-m+[]:MESSAGE: ' \
'--message=[]:MESSAGE: ' \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_vfd__git__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:vfd-git-help-command-$line[1]:"
        case $line[1] in
            (status)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(pull)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(push)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(commit)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(update)
_arguments "${_arguments_options[@]}" \
'-p+[]:PROFILES: ' \
'--profiles=[]:PROFILES: ' \
'-s+[]:SERVICES: ' \
'--services=[]:SERVICES: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_vfd__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:vfd-help-command-$line[1]:"
        case $line[1] in
            (up)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(down)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(ps)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(restart)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(git)
_arguments "${_arguments_options[@]}" \
":: :_vfd__help__git_commands" \
"*::: :->git" \
&& ret=0

    case $state in
    (git)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:vfd-help-git-command-$line[1]:"
        case $line[1] in
            (status)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(pull)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(push)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(commit)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
(update)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_vfd_commands] )) ||
_vfd_commands() {
    local commands; commands=(
'up:' \
'start:' \
'down:' \
'stop:' \
'ps:' \
'status:' \
'restart:' \
'logs:' \
'list:' \
'list-hosts:' \
'git:Runs a git commandline command' \
'update:Updates the vfd tool' \
'self-update:Updates the vfd tool' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'vfd commands' commands "$@"
}
(( $+functions[_vfd__git__commit_commands] )) ||
_vfd__git__commit_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git commit commands' commands "$@"
}
(( $+functions[_vfd__git__help__commit_commands] )) ||
_vfd__git__help__commit_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git help commit commands' commands "$@"
}
(( $+functions[_vfd__help__git__commit_commands] )) ||
_vfd__help__git__commit_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help git commit commands' commands "$@"
}
(( $+functions[_vfd__down_commands] )) ||
_vfd__down_commands() {
    local commands; commands=()
    _describe -t commands 'vfd down commands' commands "$@"
}
(( $+functions[_vfd__help__down_commands] )) ||
_vfd__help__down_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help down commands' commands "$@"
}
(( $+functions[_vfd__git_commands] )) ||
_vfd__git_commands() {
    local commands; commands=(
'status:' \
'pull:' \
'push:' \
'commit:' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'vfd git commands' commands "$@"
}
(( $+functions[_vfd__help__git_commands] )) ||
_vfd__help__git_commands() {
    local commands; commands=(
'status:' \
'pull:' \
'push:' \
'commit:' \
    )
    _describe -t commands 'vfd help git commands' commands "$@"
}
(( $+functions[_vfd__git__help_commands] )) ||
_vfd__git__help_commands() {
    local commands; commands=(
'status:' \
'pull:' \
'push:' \
'commit:' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'vfd git help commands' commands "$@"
}
(( $+functions[_vfd__git__help__help_commands] )) ||
_vfd__git__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git help help commands' commands "$@"
}
(( $+functions[_vfd__help_commands] )) ||
_vfd__help_commands() {
    local commands; commands=(
'up:' \
'down:' \
'ps:' \
'restart:' \
'logs:' \
'list:' \
'git:Runs a git commandline command' \
'update:Updates the vfd tool' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'vfd help commands' commands "$@"
}
(( $+functions[_vfd__help__help_commands] )) ||
_vfd__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help help commands' commands "$@"
}
(( $+functions[_vfd__help__list_commands] )) ||
_vfd__help__list_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help list commands' commands "$@"
}
(( $+functions[_vfd__list_commands] )) ||
_vfd__list_commands() {
    local commands; commands=()
    _describe -t commands 'vfd list commands' commands "$@"
}
(( $+functions[_vfd__help__logs_commands] )) ||
_vfd__help__logs_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help logs commands' commands "$@"
}
(( $+functions[_vfd__logs_commands] )) ||
_vfd__logs_commands() {
    local commands; commands=()
    _describe -t commands 'vfd logs commands' commands "$@"
}
(( $+functions[_vfd__help__ps_commands] )) ||
_vfd__help__ps_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help ps commands' commands "$@"
}
(( $+functions[_vfd__ps_commands] )) ||
_vfd__ps_commands() {
    local commands; commands=()
    _describe -t commands 'vfd ps commands' commands "$@"
}
(( $+functions[_vfd__git__help__pull_commands] )) ||
_vfd__git__help__pull_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git help pull commands' commands "$@"
}
(( $+functions[_vfd__git__pull_commands] )) ||
_vfd__git__pull_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git pull commands' commands "$@"
}
(( $+functions[_vfd__help__git__pull_commands] )) ||
_vfd__help__git__pull_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help git pull commands' commands "$@"
}
(( $+functions[_vfd__git__help__push_commands] )) ||
_vfd__git__help__push_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git help push commands' commands "$@"
}
(( $+functions[_vfd__git__push_commands] )) ||
_vfd__git__push_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git push commands' commands "$@"
}
(( $+functions[_vfd__help__git__push_commands] )) ||
_vfd__help__git__push_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help git push commands' commands "$@"
}
(( $+functions[_vfd__help__restart_commands] )) ||
_vfd__help__restart_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help restart commands' commands "$@"
}
(( $+functions[_vfd__restart_commands] )) ||
_vfd__restart_commands() {
    local commands; commands=()
    _describe -t commands 'vfd restart commands' commands "$@"
}
(( $+functions[_vfd__git__help__status_commands] )) ||
_vfd__git__help__status_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git help status commands' commands "$@"
}
(( $+functions[_vfd__git__status_commands] )) ||
_vfd__git__status_commands() {
    local commands; commands=()
    _describe -t commands 'vfd git status commands' commands "$@"
}
(( $+functions[_vfd__help__git__status_commands] )) ||
_vfd__help__git__status_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help git status commands' commands "$@"
}
(( $+functions[_vfd__help__up_commands] )) ||
_vfd__help__up_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help up commands' commands "$@"
}
(( $+functions[_vfd__up_commands] )) ||
_vfd__up_commands() {
    local commands; commands=()
    _describe -t commands 'vfd up commands' commands "$@"
}
(( $+functions[_vfd__help__update_commands] )) ||
_vfd__help__update_commands() {
    local commands; commands=()
    _describe -t commands 'vfd help update commands' commands "$@"
}
(( $+functions[_vfd__update_commands] )) ||
_vfd__update_commands() {
    local commands; commands=()
    _describe -t commands 'vfd update commands' commands "$@"
}

if [ "$funcstack[1]" = "_vfd" ]; then
    _vfd "$@"
else
    compdef _vfd vfd
fi
