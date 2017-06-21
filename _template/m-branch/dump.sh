#!/bin/bash
if [ "$#" -eq 0 ]; then 
  __blddir/client/mysqldump --defaults-file=__workdir/my.cnf --all-databases > __workdir/dump.sql
else
  __blddir/client/mysqldump --defaults-file=__workdir/my.cnf "$@" > __workdir/dump.sql
fi
