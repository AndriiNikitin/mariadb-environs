#!/bin/bash

set -e
# # TODO upgrade may fail without this - troubleshoot
# yum --showduplicates list MariaDB-server | expand
# yum -y install MariaDB-server MariaDB-client 

M7MAJOR=$1
if [ "$3" == galera ] ; then
  [ -z "$4" ] || extra=MariaDB-$4
  if [ "$M7MAJOR" == 5.5 ] || [ "$M7MAJOR" == 10.0 ] ; then
    yum -y install MariaDB-Galera MariaDB-client $extra
  else
    yum -y install MariaDB-server MariaDB-client $extra
  fi
else
  [ -z "$3" ] || extra=MariaDB-$3
  [ -z "$4" ] || extra="$extra MariaDB-$4"
  yum -y install MariaDB-server MariaDB-client $extra
fi
