#!/bin/bash
for eid in $(cat __clusterdir/nodes.lst) ; do
  echo -n $eid : 
  echo $(__clusterdir/../$eid*/cleanup.sh "$@")
done
