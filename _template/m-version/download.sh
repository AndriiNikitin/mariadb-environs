#!/bin/bash

[ -f common.sh ] && source common.sh

# example url ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

file=ftp://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

file1=http://mirrors.dotsrc.org/mariadb/mariadb-__version/bintar-linux-x86_64/mariadb-__version-linux-x86_64.tar.gz

mkdir -p __workdir/../_depot/m-tar/__version

(
cd __workdir/../_depot/m-tar/__version

function cleanup {
  [ -z "$wgetpid" ] || kill "$wgetpid" 2>/dev/null
}

trap cleanup INT TERM

if [ ! -f "$(basename $file)"  ] ; then
  echo downloading "$file"
  ( wget -q -np -nc "$file" || wget -q -np -nc "$file1" )&
  wgetpid=$!
  while kill -0 $wgetpid 2>/dev/null ; do
    sleep 10
    echo -n .
  done
  wait $wgetpid
  res=$?
  wgetpid=""
  if [ "$res" -ne 0 ] ; then
    >&2 echo "failed to download '$file1' ($res)"
    exit $res 
  fi
fi

if [ -f "$(basename $file)" ] ; then
  if [ ! -x bin/mysqld ] ; then
    tar -zxf "$(basename $file)" ${ERN_M_TAR_EXTRA_FLAGS} --strip 1
  fi
fi
)
:

