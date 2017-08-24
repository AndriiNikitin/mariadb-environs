#!/bin/bash
for eid in $(cat __clusterdir/nodes.lst) ; do
  echo -n $eid : 
  if [ -f __clusterdir/../$eid*/dt/error.log ] ; then
    tail -n${1:-20} __clusterdir/../$eid*/dt/error.log
  else
    echo no logs found
  fi
done
