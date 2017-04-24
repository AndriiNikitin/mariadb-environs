#!/bin/bash

set -e
. common.sh

# assign arguments in reverse order
((i=$#))

[[ "$i" -ge 1 ]] && mdb_versions=${!i} && ((i--))
[[ "$i" -ge 1 ]] && maxscale_versions=${!i} && ((i--))
[[ "$i" -ge 1 ]] && install_xtrabackup=${!i} && ((i--))

set -x

source <(cat <<'EOD'
cat /etc/*release
echo mdb_versions=$mdb_versions
set -e
while
  read mdbver mdb_versions<<EOK
$mdb_versions
EOK
  read maxscalever1 maxscale_versions<<EON
$maxscale_versions
EON
[ ! -z "$maxscalever1" ] && maxscalever=$maxscalever1
[ ! -z "$mdbver" ]
do
  if [ $(detect_yum) == apt ] ; then
    export DEBIAN_FRONTEND=noninteractive
  else
    echo yum clean all
  fi

  mdbvermajor=$mdbver
  [[ $mdbver =~ .*\..*\..* ]] && mdbvermajor=${mdbver%.*}
  
  opts=--mariadb-server-version=mariadb-$mdbver
  [ -z $maxscalever ] || opts="$opts --mariadb-maxscale-version=$maxscalever"

  curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- $opts
  if [ $(detect_yum) == apt ] ; then
    pkgs="mariadb-server-$mdbvermajor mariadb-client-$mdbvermajor"
    [ -z "$maxscalever" ] || pkgs="$pkgs maxscale"
    [ -z "$install_xtrabackup" ] || pkgs="$pkgs percona-xtrabackup"
    apt-get install -y $pkgs
  else
    pkgs="MariaDB-server MariaDB-client"
    [ -z $maxscalever ] || pkgs="$pkgs maxscale"
    [ -z "$install_xtrabackup" ] || pkgs="$pkgs percona-xtrabackup"
    yum install -y $pkgs
  fi
  # must sleep a little as on some environments background job may need to upgrade
  mysqld_safe &
  sleep 10
  mysql_upgrade
  mysql --version
  mysqladmin shutdown || :
  sleep 3
  if ! [[ $(mysql --version) =~ $version ]] ; then
    >&2 echo "Client version mismatch: expected: ($version) have ($(mysql --version))"
    exit 15
  elif ! [[ $(mysqld --no-defaults --version) =~ $version ]] ; then
    >&2 echo "Server version mismatch: expected: ($version) have ($(mysqld --no-defaults --version))"
    exit 15
  elif ! [ -z "$maxscalever" ] && ! [[ $(maxscale --version) =~ $maxscalever ]] ; then
    >&2 echo "MaxScale version mismatch: expected: ($maxscalever) have ($(maxscale --version))"
    exit 15
  elif [ ! -z "$install_xtrabackup" ] && ! xtrabackup --version ; then
    >&2 echo "xtrabackup doesn't seem to be installed"
    exit 15
  fi
done
EOD
)

