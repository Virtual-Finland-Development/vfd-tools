_vfd() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="vfd"
                ;;
            vfd,down)
                cmd="vfd__down"
                ;;
            vfd,git)
                cmd="vfd__git"
                ;;
            vfd,help)
                cmd="vfd__help"
                ;;
            vfd,hosts)
                cmd="vfd__list"
                ;;
            vfd,list)
                cmd="vfd__list"
                ;;
            vfd,logs)
                cmd="vfd__logs"
                ;;
            vfd,ps)
                cmd="vfd__ps"
                ;;
            vfd,restart)
                cmd="vfd__restart"
                ;;
            vfd,self-update)
                cmd="vfd__update"
                ;;
            vfd,start)
                cmd="vfd__up"
                ;;
            vfd,status)
                cmd="vfd__ps"
                ;;
            vfd,stop)
                cmd="vfd__down"
                ;;
            vfd,up)
                cmd="vfd__up"
                ;;
            vfd,update)
                cmd="vfd__update"
                ;;
            vfd__git,help)
                cmd="vfd__git__help"
                ;;
            vfd__git,pull)
                cmd="vfd__git__pull"
                ;;
            vfd__git,push)
                cmd="vfd__git__push"
                ;;
            vfd__git,status)
                cmd="vfd__git__status"
                ;;
            vfd__git__help,help)
                cmd="vfd__git__help__help"
                ;;
            vfd__git__help,pull)
                cmd="vfd__git__help__pull"
                ;;
            vfd__git__help,push)
                cmd="vfd__git__help__push"
                ;;
            vfd__git__help,status)
                cmd="vfd__git__help__status"
                ;;
            vfd__help,down)
                cmd="vfd__help__down"
                ;;
            vfd__help,git)
                cmd="vfd__help__git"
                ;;
            vfd__help,help)
                cmd="vfd__help__help"
                ;;
            vfd__help,list)
                cmd="vfd__help__list"
                ;;
            vfd__help,logs)
                cmd="vfd__help__logs"
                ;;
            vfd__help,ps)
                cmd="vfd__help__ps"
                ;;
            vfd__help,restart)
                cmd="vfd__help__restart"
                ;;
            vfd__help,up)
                cmd="vfd__help__up"
                ;;
            vfd__help,update)
                cmd="vfd__help__update"
                ;;
            vfd__help__git,pull)
                cmd="vfd__help__git__pull"
                ;;
            vfd__help__git,push)
                cmd="vfd__help__git__push"
                ;;
            vfd__help__git,status)
                cmd="vfd__help__git__status"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        vfd)
            opts="-p -s -h -V --generate-autocomplete --profiles --services --workdir --help --version up down ps restart logs list git update help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --generate-autocomplete)
                    COMPREPLY=($(compgen -W "bash elvish fish powershell zsh" -- "${cur}"))
                    return 0
                    ;;
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                --workdir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__down)
            opts="-p -s -h --no-traefik --no-state --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git)
            opts="-p -s -h --profiles --services --help status pull push help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__help)
            opts="status pull push help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__help__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__help__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__help__push)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__help__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__pull)
            opts="-p -s -h --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__push)
            opts="-p -s -h --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__git__status)
            opts="-p -s -h --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help)
            opts="up down ps restart logs list git update help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__down)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__git)
            opts="status pull push"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__git__pull)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__git__push)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__git__status)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 4 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__list)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__logs)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__ps)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__restart)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__up)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__help__update)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__list)
            opts="-p -s -h --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__logs)
            opts="-p -s -h --no-state --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__ps)
            opts="-p -s -h --no-state --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__restart)
            opts="-p -s -h --no-state --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__up)
            opts="-p -s -h --no-traefik --no-detach --no-state --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        vfd__update)
            opts="-p -s -h --profiles --services --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --profiles)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -W "access-to-finland virtual-finland external-service-demo status-admin" -- "${cur}"))
                    return 0
                    ;;
                --services)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                -s)
                    COMPREPLY=($(compgen -W "authentication-gw users-api testbed-api external-service-demo access-to-finland-demo-front status-info-api status-admin codesets tmt-productizer JobsInFinland.Api.Productizer virtual-finland prh-mock" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

complete -F _vfd -o bashdefault -o default vfd
