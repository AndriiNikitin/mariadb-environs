#!/bin/bash
mysql_upgrade --defaults-file=__workdir/my.cnf "$@"
