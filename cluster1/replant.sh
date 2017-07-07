#!/bin/bash

[ -z "$1" ] && exit 1

for eid in $(cat ~/spd/cluster1/nodes.lst) ; do
  ./replant.sh $eid-$1
done
