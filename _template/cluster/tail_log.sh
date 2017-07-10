#!/bin/bash
for eid in $(cat __clusterdir/nodes.lst) ; do
  echo -n $eid : 
  if [ -f $eid*/dt/error.log ] ; then
    tail -n${1:-20} $eid*/dt/error.log
  else
    echo no logs found
  fi
done
