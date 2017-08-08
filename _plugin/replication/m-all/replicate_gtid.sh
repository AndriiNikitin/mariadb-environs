#!/bin/bash

master_environ_id=$1
# todo check if master environ is remote (e.g. docker)
master_host=127.0.0.1
slave_host=127.0.0.1

if [ -d $master_environ_id* ] ; then 
  set -e
  $master_environ_id*/sql.sh "create user if not exists root@$slave_host"
  $master_environ_id*/sql.sh "GRANT REPLICATION SLAVE ON *.* TO root@$slave_host"
  # parse actual master port
  set -- $($master_environ_id*/sql.sh 'show variables like "port"')
  master_port=$2

  __workdir/sql.sh "change master to master_host='$master_host', master_port=$master_port, master_user='root', master_use_gtid=current_pos; start slave"
else
  echo "Expected environ id as first parameter, got ($master_environ_id)" 2>1
  # set errorlevel
  ( exit 1 )
fi
