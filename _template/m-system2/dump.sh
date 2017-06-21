#!/bin/bash
if [ "$#" -eq 0 ]; then 
  mysqldump --defaults-file=__workdir/my.cnf --all-databases > __workdir/dump.sql
else
  mysqldump --defaults-file=__workdir/my.cnf "$@" > __workdir/dump.sql
fi
