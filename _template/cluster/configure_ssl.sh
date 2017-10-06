#!/bin/bash
set -e

for eid in $(cat __clusterdir/nodes.lst) ; do
  __clusterdir/../$eid*/configure_ssl.sh
done
