#!/usr/bin/env bash

TARGET=""

# Retrieve the machine's operating system information
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Define the target string based on the operating system and architecture
if [ -z "${OS}" ] || [ -z "${ARCH}" ]; then
    echo "Unable to determine operating system and architecture"
    exit 1
fi

if [ "${OS}" = "darwin" ]; then
    if [ "${ARCH}" = "x86_64" ]; then
        TARGET="x86_64-apple-darwin"
    elif [ "${ARCH}" = "aarch64" ]; then
        TARGET="${ARCH}-apple-darwin"
    else
        echo "Unsupported architecture: ${ARCH}"
        exit 1
    fi
elif [ "${OS}" = "linux" ]; then
    if [ "${ARCH}" = "x86_64" ]; then
        TARGET="x86_64-unknown-linux-gnu"
    elif [ "${ARCH}" = "armv7l" ]; then
        TARGET="armv7-unknown-linux-gnueabihf"
    elif [ "${ARCH}" = "aarch64" ]; then
        TARGET="aarch64-unknown-linux-gnu"
    else
        echo "Unsupported architecture: ${ARCH}"
        exit 1
    fi
else
    echo "Unsupported operating system: ${OS}"
    exit 1
fi

echo "$TARGET"