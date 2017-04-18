#!/bin/bash

[ -f common.sh ] && source common.sh

# example url ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

FILE=ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

mkdir -p __workdir/../_depot/m-tar/__version

cd __workdir/../_depot/m-tar/__version
[[ -f $(basename $FILE) ]] || { wget -nc $FILE && tar -zxf $(basename $FILE) ${ERN_M_TAR_EXTRA_FLAGS:-\--exclude='mysql-test'} --strip 1; }
cd __workdir/..