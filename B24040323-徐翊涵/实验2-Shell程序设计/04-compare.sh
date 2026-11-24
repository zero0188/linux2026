#!/usr/bin/env bash

printf '%s\n' 'Enter the first integer:'
IFS= read -r first || exit 2
printf '%s\n' 'Enter the second integer:'
IFS= read -r second || exit 2

if ! [ "$first" -eq "$first" ] 2>/dev/null || ! [ "$second" -eq "$second" ] 2>/dev/null; then
    printf '%s\n' 'Both values must be integers.' >&2
    exit 2
fi

if [ "$first" -gt "$second" ]; then
    printf '%s is greater than %s\n' "$first" "$second"
elif [ "$first" -lt "$second" ]; then
    printf '%s is less than %s\n' "$first" "$second"
else
    printf '%s is equal to %s\n' "$first" "$second"
fi
