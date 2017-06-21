#!/bin/bash
if [ "$#" -eq 0 ]; then 
  __workdir/../_depot/m-tar/__version/bin/mysqldump --defaults-file=__workdir/my.cnf --all-databases > __workdir/dump.sql
else
  __workdir/../_depot/m-tar/__version/bin/mysqldump --defaults-file=__workdir/my.cnf "$@" > __workdir/dump.sql
fi
