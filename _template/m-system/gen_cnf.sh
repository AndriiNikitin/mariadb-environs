#!/bin/bash

cat > __workdir/my.cnf <<EOL
[client]
user=root
port=3306
socket=__datadir/my.sock

[mysqld_safe]
skip-syslog

[mysqld]
server_id=__wid
port=3306
datadir=__datadir
socket=__datadir/my.sock
pid_file=__datadir/p.id
innodb_log_file_size=15M
log-error=/var/lib/mysql/error.log

!include __workdir/mysqldextra.cnf
EOL

cat > __workdir/mysqldextra.cnf <<EOL
[mysqld]
EOL

[ ! -z "$1" ] && for o in $@ ; do
  option_name=${o%%=*}
  option_value=${o#*=}

  if [ -f __workdir/"$option_name".sh ] && [ "$option_value" == 1 ] ; then
    mkdir -p __workdir/config_load
    cp __workdir/"$option_name".sh  __workdir/config_load/
  else
    echo $o >> __workdir/mysqldextra.cnf
  fi
done


# shopt -s nullglob

[ -d __workdir/config_load ] && for config_script in __workdir/config_load/*
do
  . $config_script
done

:

