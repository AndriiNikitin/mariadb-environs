#!/bin/bash
set -e

[ -f common.sh ] || { >&2 echo 'Script must be run from environs root folder'; exit 2; }

for plugin in "$@" ; do
  if [ "$(find _plugin/$plugin -maxdepth 0 -type d -empty | wc -l)" -ne 0 ] ; then
    git clone --depth=1 https://github.com/AndriiNikitin/mariadb-environs-$plugin _plugin/$plugin
  else
    (cd _plugin/$plugin && git pull)
  fi
done

