#!/bin/bash
mysqld_safe=$(which mysqld_safe 2>/dev/null) || mysqld_safe=/usr/local/mysql/bin/mysqld_safe
echo calling $mysqld_safe

$mysqld_safe --defaults-file=__workdir/my.cnf --user=$(whoami) --skip-syslog "$@" & 
__workdir/wait_respond.sh
