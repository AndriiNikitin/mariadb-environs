#!/bin/bash
# DATADIR=__workdir/dt
MYSQLD_DATADIR=__workdir/dt
# mysql_datadir=$DATADIR
MYSQL_BLDDIR=__workdir/build
MYSQL_SRCDIR=__srcdir 

MYSQL_EXTRA_CNF=__workdir/mysqldextra.cnf
MYSQL_BASEDIR=__workdir/build

[ -f __workdir/build/extra/mariabackup//mariabackup ] && alias xtrabackup="__workdir/build/extra/mariabackup//mariabackup"
[ -f __workdir/build/extra/mariabackup//mbstream ]    && alias xbstream="__workdir/build/extra/mariabackup//mbstream"
[ -f __workdir/build/extra/mariabackup//mariabackup ] && alias innobackupex="__workdir/build/extra/mariabackup//mariabackup --innobackupex"
alias mysqld="__workdir/build/sql//mysqld"
alias mysql="__workdir/build/client//mysql --defaults-file=__workdir/my.cnf"
alias mysqladmin="__workdir/build/client//mysqladmin --defaults-file=__workdir/my.cnf"
alias mysqldump="__workdir/build/client//mysqldump --defaults-file=__workdir/my.cnf"
alias mysql_install_db="__srcdir/scripts/mysql_install_db.sh"
# export PATH=$PATH:/__workdir/build/extra/xtrabackup/

shopt -s expand_aliases

MYSQL_VERSION="$(mysqld --no-defaults --version)"
MYSQL_VERSION=${MYSQL_VERSION#*Ver }
MYSQL_VERSION=${MYSQL_VERSION%-*}

if [ -f __workdir/config_load/configure_innodb_plugin.sh ]; then
  INNODB_VERSION=$MYSQL_VERSION
  XTRADB_VERSION=""
else
  INNODB_VERSION=""
  XTRADB_VERSION=$MYSQL_VERSION
fi
