#!/bin/bash
set -e

[ -f common.sh ] && { >&2 echo 'Script must be run from environs ruoot folder'; exit 2; }

for plugin in "$@" ; do
  rm -r _plugin/$plugin
  git clone --depth=1 https://github.com/AndriiNikitin/mariadb-environs-$plugin _plugin/$plugin
done

