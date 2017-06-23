#!/bin/bash
set -e

[ -f common.sh ] || { >&2 echo 'Script must be run from environs root folder'; exit 2; }

for plugin in "$@" ; do
  if [ $(find plugin/$plugin -maxdepth 1 -type d -empty | wc -l) -eq 0 ] ; then
    (cd _plugin/$plugin && git pull)
  else
    git clone --depth=1 https://github.com/AndriiNikitin/mariadb-environs-$plugin _plugin/$plugin
  fi
done

