#!/bin/bash
set -e
bash __workdir/../_depot/m-tar/__version/scripts/mysql_install_db --defaults-file=__workdir/my.cnf --user=$(whoami) --basedir=__workdir/../_depot/m-tar/__version --force
mkdir -p __workdir/dt/test
