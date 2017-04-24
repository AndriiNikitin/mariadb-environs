#!/bin/bash

schema=$1

if ! [ -d "__datadir/$schema" ] ; then
  >&2 echo "Cannot find schema ($schema)"
  (exit 1)
else
  for t in $(__workdir/sql.sh "show tables from $schema") ; do
    __workdir/sql.sh "check table $schema.$t extended"
  done
fi
:
