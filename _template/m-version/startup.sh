#!/bin/bash
__workdir/../_depot/m-tar/__version/bin/mysqld --defaults-file=__workdir/my.cnf --user=$(whoami) "$@" & 
__workdir/wait_respond.sh
