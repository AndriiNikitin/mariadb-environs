#!/bin/bash
# DATADIR=__workdir/dt
# MYSQLD_DATADIR=/farm/m0-bb-10.1-wlad-xtrabackup/dt
# mysql_datadir=$DATADIR
MYSQL_BLDDIR=
MYSQL_SRCDIR= 

MYSQL_EXTRA_CNF=__workdir/mysqldextra.cnf
MYSQL_BASEDIR=__workdir/../_depot/m-tar/__version

# alias xtrabackup="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xtrabackup"
# alias xbstream="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xbstream"
# alias innobackupex="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xtrabackup --innobackupex"
alias mysqld="__workdir/../_depot/m-tar/__version/bin/mysqld"
alias mysql="__workdir/../_depot/m-tar/__version/bin/mysql"
alias mysqladmin="__workdir/../_depot/m-tar/__version/bin/mysqladmin"
alias mysqldump="__workdir/../_depot/m-tar/__version/bin/mysqldump"
alias mysql_install_db="__workdir/../_depot/m-tar/__version/scripts/mysql_install_db"

MYSQL_VERSION="$(__workdir/../_depot/m-tar/__version/bin/mysqld --no-defaults --version)"
MYSQL_VERSION=${MYSQL_VERSION#*Ver }
MYSQL_VERSION=${MYSQL_VERSION%-*}

if [ -f __workdir/config_load/configure_innodb_plugin.sh ]; then
  INNODB_VERSION=$MYSQL_VERSION
  XTRADB_VERSION=""
else
  INNODB_VERSION=""
  XTRADB_VERSION=$MYSQL_VERSION
fi