#!/usr/bin/env bash

set -e

scriptPath="$(cd "$(dirname "$0")" && pwd)"
RTYPE="${1:-Release}"
shift || true

EXTRA_ARGS=("$@")
IS_IOS=false

for arg in "${EXTRA_ARGS[@]}"; do
  if [[ "$arg" == "-ios" ]]; then
    IS_IOS=true
    break
  fi
done

if [[ "$OSTYPE" == "darwin"* && "$IS_IOS" == "false" ]]; then
  "$scriptPath/build-native.sh" "${RTYPE}" -osx-architectures 'arm64;x86_64' "${EXTRA_ARGS[@]}"
else
  "$scriptPath/build-native.sh" "${RTYPE}" "${EXTRA_ARGS[@]}"
fi