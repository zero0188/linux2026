#!/usr/bin/env bash

export LC_ALL=C
var3='*'
printf '%s\n' '$ echo *'
echo *
printf '%s\n' '$ echo "*"'
echo "*"
printf '%s\n' '$ echo $var3'
echo $var3
printf '%s\n' '$ echo "$var3"'
echo "$var3"
printf '%s\n' "\$ echo '\$var3'"
echo '$var3'

printf '%s\n' '$ var4=`ls -l`' '$ echo "$var4"'
var4=`ls -l`   # Use backticks here to match the experiment.
echo "$var4"
printf '%s\n' '$ var5=ls' '$ echo "`$var5`"'
var5=ls
echo "`$var5`"
