#!/bin/bash

# assign arguments in reverse order
((i=$#))

[[ "$i" -ge 1 ]] && mid=${!i} && ((i--))
[[ "$i" -ge 1 ]] && MATRIX_MDBVERSION2=${!i} && ((i--))
[[ "$i" -ge 1 ]] && MATRIX_MDBVERSION=${!i} && ((i--))

MARIADB_VERSION=${MATRIX_MDBVERSION}
MARIADB_VERSION2=${MATRIX_MDBVERSION2:-10.0}

if [ -z $MARIADB_VERSION ] ; then
  MARIADB_VERSION=$MARIADB_VERSION2
  MARIADB_VERSION2=
fi 

[[ $mid =~ [0-9] ]] || { echo "Expected MariaDB environ id as last parameter, got ($mid)" 1>&2; exit 1; }

[ -d m${mid}* ] || { echo "Cannot find environ m${mid}" 1>&2; exit 1; }

set -x
set -e

m${mid}*/install.sh $MARIADB_VERSION && \
sleep 6 && \
m${mid}*/shutdown.sh || :

m${mid}*/startup.sh && \
mysql -e "select version()"

res=$?

# if second action is not provided - just installation is being tested and we exit here
if [ ! -z $MARIADB_VERSION2 ] && [ $res -eq 0 ] ; then

  m${mid}*/shutdown.sh && \
  sleep 6 && \
  ./_system/uninstall.sh && \
  m${mid}*/install.sh ${MARIADB_VERSION2} && \
  m${mid}*/startup.sh && \
  mysql -e "select version()" && \
  mysql -e "use mysql; show tables" && \
  m${mid}*/shutdown.sh && \
  sleep 5 && \
  m${mid}*/startup.sh && \
  mysql -e "select version()"

  res=$?
  # better shutdown otherwise docker may stuck for some time at the end (?)
  m${mid}*/shutdown.sh
  sleep 3
fi

# set errorlevel without exiting parent script
(exit $res)