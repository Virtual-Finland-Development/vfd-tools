#!/usr/bin/env sh
# Navigate to the project root
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${SCRIPTPATH}/..

# Build the binary if it doesn't exist
if [ ! -f ./target/release/vfd ]; then
    echo "> Building the vfd binary..."
    make build
fi

# Execute the binary
./target/release/vfd $@