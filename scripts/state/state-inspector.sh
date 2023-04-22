#!/usr/bin/env bash
command=$1

if [ -z "${command}" ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

if [ "${command}" == "store" ]; then
   echo "${@:2}" > /state/vfd-tools.state
elif [ "${command}" == "read" ]; then
    if [ -f /state/vfd-tools.state ]; then
        cat /state/vfd-tools.state
    else
        echo ""
    fi
elif [ "${command}" == "flush" ]; then
    if [ -f /state/vfd-tools.state ]; then
        state=$(cat /state/vfd-tools.state)
        rm /state/vfd-tools.state
        echo "${state}"
    else
        echo ""
    fi
elif [ "${command}" == "clear" ]; then
    if [ -f /state/vfd-tools.state ]; then
        rm /state/vfd-tools.state
    fi
else
    echo "Unknown vfd-tools state command: ${command}"
    exit 1
fi