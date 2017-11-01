#!/bin/bash

mysql_install_db=$(which mysql_install_db 2>/dev/null) 
[ ! -z "$mysql_install_db" ] || mysql_install_db=/usr/local/mysql/scripts/mysql_install_db && addbasedir=--basedir=/usr/local/mysql
echo calling $mysql_install_db
bash $mysql_install_db --defaults-file=__workdir/my.cnf --user=$(whoami) $addbasedir --force
mkdir -p __workdir/dt/test
