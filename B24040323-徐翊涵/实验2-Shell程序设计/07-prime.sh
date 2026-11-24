#!/usr/bin/env bash

is_prime() {
    local number=$1 divisor
    for ((divisor = 2; divisor <= number / divisor; divisor++)); do
        if ((number % divisor == 0)); then
            return 1
        fi
    done
    return 0
}

input=${1:-}
if ! [[ $input =~ ^[+-]?[0-9]+$ ]] || ! [ "$input" -eq "$input" ] 2>/dev/null; then
    printf '%s\n' 'Expected one integer argument.' >&2
    exit 2
fi

# The radix prefix treats leading zeros as decimal.
if [ "$input" -ge 2 ] && is_prime "$((10#${input#+}))"; then
    printf '%s is a prime!\n' "$input"
else
    printf '%s is not a prime!\n' "$input"
fi
