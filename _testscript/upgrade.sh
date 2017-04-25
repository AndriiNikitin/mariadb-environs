#!/bin/bash

# assign arguments in reverse order
((i=$#))

[[ "$i" -ge 1 ]] && mid=${!i} && ((i--))
[[ "$i" -ge 1 ]] && mdbversions=${!i} && ((i--))
[[ "$i" -ge 1 ]] && mdbconfigs=${!i} && ((i--))

[[ $mid =~ [0-9] ]] || { echo "Expected MariaDB environ id as last parameter, got ($mid)" 1>&2; exit 1; }

set -x
set -e
./replant.sh m${mid}-system

set +e
echo try to uninstall - you may ignore errors below
m${mid}*/shutdown.sh
m${mid}*/kill9.sh
_system/uninstall.sh

set -e
first=yes

for version in $mdbversions ; do
  _template/mariadb_pre_upgrade.sh $version | bash -x

  if [ "$first" == yes ] ; then
    m${mid}*/gen_cnf.sh "$mdbconfigs"
    m${mid}*/install.sh $version
    # must sleep a little as on some environments background job will do mysql_upgrade
    sleep 5
    m${mid}*/status.sh || m${mid}*/startup.sh
    m${mid}*/mysql_upgrade.sh
    m${mid}*/load_sakila.sh
    m${mid}*/status.sh
    first=no
  else
    m${mid}*/install.sh $version
    # must sleep a little as on some environments background job will do mysql_upgrade
    sleep 5
    m${mid}*/status.sh || m${mid}*/startup.sh
    m${mid}*/mysql_upgrade.sh
    m${mid}*/check_tables.sh sakila
  fi

  mysql -e 'select version()'
  m${mid}*/assert_config.sh "$mdbconfigs"
  m${mid}*/shutdown.sh
done

