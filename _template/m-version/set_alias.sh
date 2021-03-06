#!/bin/bash
MYSQL_BLDDIR=
MYSQL_SRCDIR= 

MYSQL_EXTRA_CNF=__workdir/mysqldextra.cnf
MYSQL_BASEDIR=__workdir/../_depot/m-tar/__version

[ -f __workdir/../_depot/m-tar/__version/bin/mariabackup ] && alias xtrabackup="__workdir/../_depot/m-tar/__version/bin/mariabackup"
[ -f __workdir/../_depot/m-tar/__version/bin/mbstream ]    && alias xbstream="__workdir/../_depot/m-tar/__version/bin/mbstream"
[ -f __workdir/../_depot/m-tar/__version/bin/mariabackup ] && alias innobackupex="__workdir/../_depot/m-tar/__version/bin/mariabackup --innobackupex"
[ -f __workdir/../_depot/m-tar/__version/bin/mariabackup ] && alias mariabackup="__workdir/../_depot/m-tar/__version/bin/mariabackup"
alias mysqld="__workdir/../_depot/m-tar/__version/bin/mysqld"
alias mysql="__workdir/../_depot/m-tar/__version/bin/mysql"
alias mysqladmin="__workdir/../_depot/m-tar/__version/bin/mysqladmin"
alias mysqldump="__workdir/../_depot/m-tar/__version/bin/mysqldump"
alias mysql_install_db="__workdir/../_depot/m-tar/__version/scripts/mysql_install_db"

MYSQL_VERSION="$(__workdir/../_depot/m-tar/__version/bin/mysqld --no-defaults --version)"
MYSQL_VERSION=${MYSQL_VERSION#*Ver }
MYSQL_VERSION=${MYSQL_VERSION%-*}

if [ -f __workdir/config_load/configure_innodb_plugin.sh ] \
 || [[ $MYSQL_VERSION == 10.2* ]] \
 || [[ $MYSQL_VERSION == 10.3* ]] \
 || [[ $MYSQL_VERSION == 5.6* ]] \
 || [[ $MYSQL_VERSION == 5.7* ]] 
then
  INNODB_VERSION=$MYSQL_VERSION
  XTRADB_VERSION=""
else
  INNODB_VERSION=$MYSQL_VERSION
  XTRADB_VERSION=$MYSQL_VERSION
fi
