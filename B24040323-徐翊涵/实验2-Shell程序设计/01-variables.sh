#!/usr/bin/env bash

unset var1 var2
var1='welcome to use local variable'
var2='I am a global variable'
export var2

printf '%s\n' 'Child Bash:'
bash --noprofile --norc -c 'printf "var1=<%s>\nvar2=<%s>\n" "$var1" "$var2"'

printf '%s\n' 'Parent Bash:'
printf 'var1=<%s>\nvar2=<%s>\n' "$var1" "$var2"
