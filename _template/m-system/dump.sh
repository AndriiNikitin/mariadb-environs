#!/bin/bash
if [ "$#" -eq 0 ]; then 
  mysqldump --all-databases > __workdir/dump.sql
else
  mysqldump "$@" > __workdir/dump.sql
fi
