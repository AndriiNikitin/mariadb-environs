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

!include __workdir/mysqldextra.cnf
EOL
cat > __workdir/mysqldextra.cnf <<EOL
[mysqld]
lc_messages_dir=__workdir/../_depot/m-tar/__version/share
plugin-dir=__workdir/../_depot/m-tar/__version/lib/plugin
EOL

[ ! -z "$1" ] && for o in $@ ; do
  option_name=${o%%=*}
  option_value=${o#*=}

  if [ -f __workdir/"$option_name".sh ] ; then
    if [ "$option_value" == 1 ] ; then
      mkdir -p __workdir/config_load
      cp __workdir/"$option_name".sh  __workdir/config_load/
    elif [ "$option_value" == 0 ] ; then
      rm -f __workdir/config_load/$option_name.sh
    fi
  else
    echo $o >> __workdir/mysqldextra.cnf
  fi
done

(
shopt -s nullglob
mkdir -p __workdir/config_load

for config_script in __workdir/config_load/*
do
  . $config_script
done
)
 
