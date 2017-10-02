#!/bin/bash

set -e
# # TODO upgrade may fail without this - troubleshoot
# yum --showduplicates list MariaDB-server | expand

yum -y install MariaDB-server MariaDB-client 

if [ ! -z $3 ] ; then
  M7VER=$1
  M7MAJOR=${M7VER%\.*}
  if [ "$3" != galera ] || [ "$M7MAJOR" == 5.5 ] || [ "$M7MAJOR" == 10.0 ] ) ; then
    yum -y install MariaDB-$3
  else
    :  # do nothing 10.1+ have galera already
  fi
fi
