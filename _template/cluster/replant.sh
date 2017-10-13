#!/bin/bash

[ -z "$1" ] && exit 1

firstnode=""

for eid in $(cat __clusterdir/nodes.lst) ; do
  if [ -z "$firstnode" ] ; then
    ./replant.sh $eid-$1
    firstnode=$eid
  else
    # if first node is branch environ - the other nodes in cluster will just reuse its src and bld folders
    if [ -e "$firstnode"-$1/bld ] ; then
      ./replant.sh $eid-$1 "$(pwd)/$firstnode"-$1/src "$(pwd)/$firstnode"-$1/bld
    else
      ./replant.sh $eid-$1
    fi 
  fi
done
