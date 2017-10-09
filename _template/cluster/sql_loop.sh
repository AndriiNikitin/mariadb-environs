#!/bin/bash

# trap 'echo EXIT CLUSTER; kill $(jobs -p)' EXIT
trap "exit" INT TERM
trap "kill 0" EXIT

for eid in $(cat __clusterdir/nodes.lst) ; do
  __clusterdir/../$eid*/sql_loop.sh "$1" "$2" &
done

wait
