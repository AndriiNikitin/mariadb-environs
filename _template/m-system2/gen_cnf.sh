#!/bin/bash
cat > __workdir/my.cnf <<EOL
[xtrabackup]
user=root
port=__port

[client]
user=root
port=__port
socket=__datadir/my.sock

[mysqld]
server_id=__wid
port=__port
socket=__datadir/my.sock
datadir=__datadir
log-error=__datadir/error.log

pid_file=__datadir/p.id
EOL

shopt -s nullglob
[ -d __workdir/config_load ] && for config_script in __workdir/config_load/*
do
  . $config_script
done

:
