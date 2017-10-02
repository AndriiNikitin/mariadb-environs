#!/bin/bash

M7MAJOR=$1

# todo !! test special characters in passwords
M7ROOTPWD=
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password password '"$M7ROOTPWD"
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password_again password '"$M7ROOTPWD"

set -e

if [ "$3" == galera ] ; then
  [ -z "$4" ] || extra=mariadb-$4-$M7MAJOR

  if [ "$M7MAJOR" == 5.5 ] ||  [ "$M7MAJOR" == 10.0 ] ; then
    apt-get install -y mariadb-galera-server-$M7MAJOR mariadb-client-$M7MAJOR mariadb-server-core-$M7MAJOR $extra
  else
    apt-get install -y mariadb-server-$M7MAJOR mariadb-client-$M7MAJOR mariadb-server-core-$M7MAJOR $extra
  fi
else
  [ -z "$3" ] || extra=mariadb-$3-$M7MAJOR
  [ -z "$4" ] || extra="$extra mariadb-$4-$M7MAJOR"
  apt-get install -y mariadb-server-$M7MAJOR mariadb-client-$M7MAJOR mariadb-server-core-$M7MAJOR $extra
fi
:
