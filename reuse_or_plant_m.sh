#!/bin/bash
set -e
[ -z "$1" ] && exit 1

# first try to find if we already have environ $1
for wid in m{0..9} ; do
  # find if folder with prefix m0..m9 doesn't exist
  ls $wid-$1 &> /dev/null || continue

  # found environ, assume it is ready for usage - print and exit
  echo $wid-$1
  exit 0
done

for wid in m{0..9} ; do 
  # find if folder with prefix m0..m9 doesn't exist
  [ -z "$(find . -maxdepth 1 -type d -name "$wid*" | head -1)" ] || continue
  empty_slot=$wid && break
done


if [ -z "$empty_slot" ] ; then
  >&2 echo "Cannot find empty slot for environment, remove m{0..9}* folders" ; 
  exit 1;
else
  mkdir $empty_slot-$1
  echo $empty_slot-$1
  ./plant.sh $empty_slot-$@
fi

