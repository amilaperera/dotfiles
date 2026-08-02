#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 {fedora|alma|debian}"
    exit 1
fi

img="$1"
dockerfile="${SCRIPT_DIR}/Dockerfile.${img}"
tag="dotfiles-test-${img}"

if [[ ! -f "${dockerfile}" ]]; then
    echo "Error: Unknown distro '${img}'"
    exit 1
fi

echo "========================================"
echo "Building ${img} with tag: ${tag}"
echo "========================================"

if docker build -f "${dockerfile}" -t "${tag}" "${SCRIPT_DIR}"; then
    echo "PASS: ${img}"
else
    echo "FAIL: ${img}"
    exit 1
fi
