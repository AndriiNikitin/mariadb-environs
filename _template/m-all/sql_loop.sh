#!/bin/bash

query=${1:-"select version(); do sleep(1);"}
sleep=${2}

mkdir -p __workdir/jobs

echo $1 $2 >> __workdir/jobs/$$.log

while : ; do
  __workdir/sql.sh "$query" >>__workdir/jobs/$$.log 2>&1 || :
  [ -z "$sleep" ] || sleep $sleep
done
:
