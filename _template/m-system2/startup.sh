#!/bin/bash
mysqld_safe --defaults-file=__workdir/my.cnf --user=$(whoami) --loose-syslog=0 "$@" & 
__workdir/wait_respond.sh
