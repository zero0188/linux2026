#!/usr/bin/env bash

shopt -s nullglob dotglob
count=0
for path in *; do
    if [[ -f $path && -x $path ]]; then
        ((count += 1))
    fi
done
printf 'Total of %d files executable\n' "$count"
