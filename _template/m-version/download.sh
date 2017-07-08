#!/bin/bash

[ -f common.sh ] && source common.sh

# example url ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

file=ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

mkdir -p __workdir/../_depot/m-tar/__version

(
cd __workdir/../_depot/m-tar/__version

function cleanup {
  [ -z "$wgetpid" ] || kill "$wgetpid" 2>/dev/null
}

trap cleanup INT TERM

if [ ! -f "$(basename $file)"  ] ; then
  echo downloading "$file"
  wget -nc $file &
  wgetpid=$!
  while kill -0 $wgetpid 2>/dev/null ; do
    sleep 10
    echo -n .
  done
  wait $wgetpid
  wgetpid=""
fi

if [ -f "$(basename $file)" ] ; then
  if [ ! -x bin/mysqld ] ; then
    tar -zxf "$(basename $file)" ${ERN_M_TAR_EXTRA_FLAGS} --strip 1
  fi
fi
)
:

