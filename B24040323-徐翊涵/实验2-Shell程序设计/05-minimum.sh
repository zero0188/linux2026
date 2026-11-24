#!/usr/bin/env bash

if (( $# == 0 )); then
    set -- 8 2 18 0 -3 87
fi

smallest=$1
for value in "$@"; do
    if ! [ "$value" -eq "$value" ] 2>/dev/null; then
        printf 'Invalid integer: %s\n' "$value" >&2
        exit 2
    fi
    if [ "$value" -lt "$smallest" ]; then
        smallest=$value
    fi
done
printf '%s\n' "$smallest"
