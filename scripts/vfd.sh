#!/usr/bin/env bash
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PROJECT_PATH=${SCRIPT_PATH}/../
VFD_TOOLS_IMAGE="vfd-tools:v1"

# Check if docker is installed
if ! command -v docker &> /dev/null
then
    echo "docker could not be found"
    exit 1
fi

# Check if vfd-tools image is available
if ! docker image inspect ${VFD_TOOLS_IMAGE} &> /dev/null
then
    # Build vfd-tools image
    docker build -t ${VFD_TOOLS_IMAGE} ${PROJECT_PATH}
fi

docker run --rm -v ${PROJECT_PATH}/settings.json:/vfd-tools/settings.json ${VFD_TOOLS_IMAGE} $@