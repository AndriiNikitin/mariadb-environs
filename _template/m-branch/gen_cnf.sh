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
lc_messages_dir=__blddir/sql/share
plugin-dir=__workdir/plugin
EOL

# shopt -s nullglob
mkdir -p __workdir
mkdir -p __datadir

[ ! -z "$1" ] && for o in $1 ; do
  option_name=${o%%=*}
  option_value=${o#*=}

  if [ -f __workdir/"$option_name" ] && [ "$option_value" == 1 ] ; then
    mkdir -p __workdir/config_load
    cp __workdir/"$option_name"  __workdir/config_load/
  else
    echo $o >> __workdir/mysqldextra.cnf
  fi
done


# shopt -s nullglob
mkdir -p __datadir

[ -d __workdir/config_load ] && for config_script in __workdir/config_load/*
do
  . $config_script
done

:
 
