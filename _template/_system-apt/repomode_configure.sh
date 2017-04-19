#!/bin/bash

M7MAJOR=$1

. common.sh

PUBKEY=0xcbcb082a1bb943db

declare -r DISTNAME=$(detect_distname)
declare -r DISTVER=$(detect_distver)
declare -r DISTCODE=$(detect_distcode)

if [ "$DISTNAME" == debian ] ; then
  [[ "$DISTVER" -gt 8 ]] && PUBKEY=0xF1656F24C74CD1D8 
# todo troubleshoot
  [[ "$DISTVER" -gt 8 ]] && retry 5 apt-get install -y gnupg2
elif [ "$DISTNAME" == ubuntu ] ; then
  [[ $DISTVER == 16* ]] && PUBKEY=0xF1656F24C74CD1D8
else
  echo "Unexpected distribution name; got ($DISTNAME)";
  exit 2;
fi

set -e

# retry few times because sometimes server doesn't respond properly
retry 5 apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 $PUBKEY 

echo 'deb [arch=amd64,i386] http://mirror.one.com/mariadb/repo/'$M7MAJOR'/'$DISTNAME' '$DISTCODE' main' >> /etc/apt/sources.list

# ignore eventual errors as they may come from unrelated repos
apt-get update || :

# rm -rf /var/lib/mysql/debian-*.flag

