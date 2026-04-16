#!/usr/bin/env bash

set -e

scriptPath="`dirname \"$0\"`"
RTYPE="${1:-Release}"
shift || true

EXTRA_ARGS="$@"

if [[ "$OSTYPE" == "darwin"* ]]; then
  $scriptPath/build-native.sh ${RTYPE} -osx-architectures 'arm64;x86_64' ${EXTRA_ARGS}
else
  $scriptPath/build-native.sh ${RTYPE} ${EXTRA_ARGS}
fi