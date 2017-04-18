#!/bin/bash
set -e

[ ! -z "$1" ] || exit 1

. common.sh

wwid=${1:0:2}
wid=${wwid:1:2}
wtype=${wwid:0:1}

[[ $wid =~ [0-9] ]] || exit 1

oldworkdir=$(find . -maxdepth 1 -type d -name "$wwid*" | head -1)

# check that only one or none directory exists
[ $(find . -maxdepth 1 -path ./$wwid\* | wc -l) -le 1 ] || { >&2 echo "Found several directories matching $wwid*" ; exit 1; }

if [ ! -z "$oldworkdir" ] && [ -d "$oldworkdir" ] ; then
  # cleaning old instance
  for cleanupscript in "$oldworkdir"/*cleanup.sh ; do
    [ -x $cleanupscript ] && $cleanupscript
  done

  retry 5 find . -maxdepth 1 -type d -name "$wwid"\* -exec rm -rf {} +
fi

mkdir "$1"
./plant.sh "$1"