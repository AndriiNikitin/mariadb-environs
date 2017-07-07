#!/bin/bash
if [ "$#" -eq 0 ]; then 
  mysqldump --all-databases
else
  mysqldump "$@"
fi
