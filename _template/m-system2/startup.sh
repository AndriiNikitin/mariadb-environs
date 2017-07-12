#!/bin/bash
mysqld_safe --defaults-file=__workdir/my.cnf --user=$(whoami) --skip-syslog "$@" & 
__workdir/wait_respond.sh
