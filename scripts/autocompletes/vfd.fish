complete -c vfd -n "__fish_use_subcommand" -l generate-autocomplete -r -f -a "{bash	,elvish	,fish	,powershell	,zsh	}"
complete -c vfd -n "__fish_use_subcommand" -s p -l profiles -r
complete -c vfd -n "__fish_use_subcommand" -s s -l services -r
complete -c vfd -n "__fish_use_subcommand" -l workdir -d 'Sets the working directory' -r
complete -c vfd -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c vfd -n "__fish_use_subcommand" -f -a "up"
complete -c vfd -n "__fish_use_subcommand" -f -a "down"
complete -c vfd -n "__fish_use_subcommand" -f -a "ps"
complete -c vfd -n "__fish_use_subcommand" -f -a "restart"
complete -c vfd -n "__fish_use_subcommand" -f -a "logs"
complete -c vfd -n "__fish_use_subcommand" -f -a "list"
complete -c vfd -n "__fish_use_subcommand" -f -a "git" -d 'Runs a git commandline command'
complete -c vfd -n "__fish_use_subcommand" -f -a "update" -d 'Updates the vfd tool'
complete -c vfd -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c vfd -n "__fish_seen_subcommand_from up" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from up" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from up" -l no-traefik -d 'Skips the traefik domain routing'
complete -c vfd -n "__fish_seen_subcommand_from up" -l no-detach -d 'Runs the docker compose command without detaching'
complete -c vfd -n "__fish_seen_subcommand_from up" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from down" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from down" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from down" -l no-traefik -d 'Skips the traefik domain routing'
complete -c vfd -n "__fish_seen_subcommand_from down" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from ps" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from ps" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from ps" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from restart" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from restart" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from logs" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from logs" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from logs" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from list" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from list" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "status"
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "pull"
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "push"
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "commit"
complete -c vfd -n "__fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from status" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from status" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from pull" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from pull" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from pull" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from push" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from push" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from push" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from commit" -s m -l message -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from commit" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from commit" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from commit" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "status"
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "pull"
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "push"
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "commit"
complete -c vfd -n "__fish_seen_subcommand_from git; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c vfd -n "__fish_seen_subcommand_from update" -s p -l profiles -r
complete -c vfd -n "__fish_seen_subcommand_from update" -s s -l services -r
complete -c vfd -n "__fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "up"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "down"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "ps"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "restart"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "logs"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "list"
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "git" -d 'Runs a git commandline command'
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "update" -d 'Updates the vfd tool'
complete -c vfd -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from up; and not __fish_seen_subcommand_from down; and not __fish_seen_subcommand_from ps; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from update; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c vfd -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit" -f -a "status"
complete -c vfd -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit" -f -a "pull"
complete -c vfd -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit" -f -a "push"
complete -c vfd -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from git; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from pull; and not __fish_seen_subcommand_from push; and not __fish_seen_subcommand_from commit" -f -a "commit"
