#!/bin/bash

M7MAJOR=$1

# todo !! test special characters in passwords
M7ROOTPWD=
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password password '"$M7ROOTPWD"
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password_again password '"$M7ROOTPWD"

set -e

apt-get install -y mariadb-server-$M7MAJOR mariadb-client-$M7MAJOR mariadb-server-core-$M7MAJOR

if [ ! -z $3 ] ; then
  if [ "$3" != galera ] || [ "$M7MAJOR" == 5.5 ] ||  [ "$M7MAJOR" == 10.0 ] ; then
    apt-get install -y mariadb-$3-$M7MAJOR
  else
    :
  fi
fi
:
