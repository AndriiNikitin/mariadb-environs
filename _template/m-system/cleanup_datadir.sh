#!/bin/bash
__workdir/kill9.sh
# this should fail but we try in case if pid file is accidentally removed
if [ -f /etc/mysql/my.cnf ] || [ -f /etc/my.cnf ] ; then 
   mysqladmin shutdown 2>/dev/null && sleep 15
fi

d="$(date +%Y%m%d%H%M%S)"
mv /var/lib/mysql /var/lib/mysql.$d
mkdir /var/lib/mysql

mkdir /var/lib/mysql.$d/_oldcfg
mv /etc/my.cnf* /var/lib/mysql.$d/_oldcfg/ || :
mv /etc/mysql/my.cnf /var/lib/mysql.$d/_oldcfg/ || :
