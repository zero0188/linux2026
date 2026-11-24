#!/usr/bin/env bash

hour=${1:-$(date +%H)}
case $hour in
    0[1-9]|1[01]) printf '%s\n' 'Good morning!' ;;
    1[2-7])       printf '%s\n' 'Good afternoon!' ;;
    00|1[89]|2[0-3]) printf '%s\n' 'Good evening!' ;;
    *) printf '%s\n' 'Expected a two-digit hour from 00 to 23.' >&2; exit 2 ;;
esac
