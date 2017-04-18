#!/bin/bash
mysql --defaults-file=__workdir/my.cnf -BN -e "$@"
