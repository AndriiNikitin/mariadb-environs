#!/bin/bash
if [ -f __datadir/p.id ]
then
  pid=$(cat __datadir/p.id)
  kill -9 $pid 2>/dev/null
  wait $pid 2>/dev/null 
  if [ $? -ne 0 ] 
  then
    while [ ! -z "$(ps ax | grep -- mysqld | grep -- $pid)" ]
    do
      echo "Process $pid still exists, sleeping 1 sec"
      sleep 1
    done
  fi
  rm -f __datadir/p.id 
fi
