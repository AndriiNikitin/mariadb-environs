#!/bin/bash
# mkdir -p /etc/mysql
cat > /etc/my.cnf <<EOL
[client]
user=root
port=3306
socket=__datadir/my.sock

[mysqld]
server_id=__wid
port=3306
datadir=__datadir
socket=__datadir/my.sock
pid_file=__datadir/p.id


!include /etc/mysqldextra.cnf
EOL
cat > /etc/mysqldextra.cnf <<EOL
[mysqld]
EOL

shopt -s nullglob

[ -d __workdir/config_load ] && for config_script in __workdir/config_load/*
do
  . $config_script
done

:

