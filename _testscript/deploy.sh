#!/bin/bash

# assign arguments in reverse order
((i=$#))

[[ "$i" -ge 1 ]] && mid=${!i} && ((i--))
[[ "$i" -ge 1 ]] && MATRIX_MDBVERSION=${!i} && ((i--))

MARIADB_VERSION=${MATRIX_MDBVERSION:-10.1}

[[ $mid =~ [0-9] ]] || { echo "Expected MariaDB environ id as last parameter, got ($mid)" 1>&2; exit 1; }

[ -d m${mid}* ] || { echo "Cannot find environ m${mid}" 1>&2; exit 1; }

set -x
echo try to uninstall - ignore any errors


m${mid}*/shutdown.sh
m${mid}*/kill9.sh
_system/uninstall.sh

set -e

m${mid}*/install.sh $MARIADB_VERSION && \
sleep 6 && \
m${mid}*/shutdown.sh || :

m${mid}*/startup.sh && \
mysql -e "select version()"
