#!/bin/bash
# DATADIR=__workdir/dt
# MYSQLD_DATADIR=/farm/m0-bb-10.1-wlad-xtrabackup/dt
# mysql_datadir=$DATADIR
MYSQL_BLDDIR=
MYSQL_SRCDIR= 

MYSQL_EXTRA_CNF=__workdir/mysqldextra.cnf
MYSQL_BASEDIR=/usr

# alias xtrabackup="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xtrabackup"
# alias xbstream="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xbstream"
# alias innobackupex="/farm/m0-bb-10.1-wlad-xtrabackup/build/extra/xtrabackup//xtrabackup --innobackupex"
alias mysqld="/usr/sbin/mysqld"
alias mysql="/usr/bin/mysql"
alias mysqladmin="/usr/bin/mysqladmin"
alias mysqldump="/usr/bin/mysqldump"
alias mysql_install_db="/usr/bin/mysql_install_db"

MYSQL_VERSION="$(/usr/sbin/mysqld --no-defaults --version)"
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
  INNODB_VERSION=""
  XTRADB_VERSION=$MYSQL_VERSION
fi
