#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

pkgToRemoveListFull="mysql-server mysql-server-core mysql-client libmysqlclient libmariadbclient mysql-common mariadb-common mariadb-client-core mariadb-client mariadb-server-core  mariadb-server"
pkgToRemoveList=""
for pkgToRemove in $(echo $pkgToRemoveListFull); do
  $(dpkg --status $pkgToRemove &> /dev/null)
  if [[ $? -eq 0 ]]; then
    pkgToRemoveList="$pkgToRemoveList $pkgToRemove"
  fi
done
apt-get --yes --purge remove $pkgToRemoveList
