#!/bin/bash
for eid in $(cat ~/spd/cluster1/nodes.lst) ; do
  echo -n $eid : 
  echo $($eid*/status.sh)
done
