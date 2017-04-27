#!/bin/bash

# The script doesn't try to fix all problems
# The script only attempts to fix some (most frequent most simple) cases

# consider only as suggestions
# do not rely on results
# use on own risk

newversion="$1"
FOUND=no

function dodie()
{
  [ -z "$1" ] || >2& echo "$1"
  exit 1
}

[ ! -z "$newversion" ] || dodie 'Expected New Version as parameter'


if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

function commentout()
{
  keyword=$1
  value=$2
  [ -z "$keyword" ] && return

  [ ! -z "$value" ] && value="[[:space:]]*=[[:space:]]*${value}"

  # not FOUND
  res=1

  for location in ${@:3} ; do
    # append /dev/null to trick grep into always printing file names
    grep -rniE "^[[:space:]]*${keyword}${value}" ${location} /dev/null | while read -r triplet ; do
     file=${triplet%%:*}
     couple=${triplet#*:}
     lineno=${couple%%:*}
     text=${couple#*:}

     echo "## in file: $file line: $lineno"
     echo "# $text"
     echo '## Suggested fix:'
     echo "sed -i '${lineno}s/\(^.*$keyword.*\)/#\ \1/i' $file"
     echo ''
     echo ''
    done
    [ ${PIPESTATUS[0]} -eq 0 ] && res=0
  done
  test $res -eq 0 && FOUND=yes

  return $res
}

if [[ $newversion =~ ^10\.[2|3] ]]
then
  commentout archive off /etc/my*
  commentout archive 0 /etc/my*

  commentout blackhole off /etc/my*
  commentout blackhole 0 /etc/my*

#  commentout plugin.load.add ha_innodb /etc/mysql && commentout ignore.builtin.innodb '' /etc/mysql
#  commentout plugin.load ha_innodb /etc/mysql     && commentout ignore.builtin.innodb '' /etc/mysql
  commentout plugin.load.add ha_innodb /etc/my*   && commentout ignore.builtin.innodb '' /etc/my*
  commentout plugin.load ha_innodb /etc/my*       && commentout ignore.builtin.innodb '' /etc/my*

fi


if [[ $newversion =~ 10\.[2|3] ]] \
  && [ -f /etc/mysql/conf.d/mariadb-enterprise.cnf ] \
  && [ ! -f /etc/mysql/conf.d/unix_socket.cnf ] \
  && [[ $(mysql --version) == *10\.1* ]]
then
    echo '## Upgrade from 10.1 Enterprise detected, it is recommended to enable unix_socket plugin like below'
    echo 'echo [mysqld] >> /etc/mysql/conf.d/unix_socket.cnf'
    echo 'echo plugin-load-add=auth_socket >> /etc/mysql/conf.d/unix_socket.cnf'
    echo ''
    echo ''
    FOUND=yes
fi

if [ "$FOUND" == no ] ; then
  echo "## Basic check wasn't able to find known typical issues"
else
  echo "## Some basic issues have been detected, others may still present - refer documentation, test upgrade, have backup, etc"
fi


fi
(true)

