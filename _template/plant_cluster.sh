#!/bin/bash

set -e

. common.sh

[ ! -z "$1" ] || { echo expected folder for cluster scripts as first parameter ; exit 1; }

clusterdir="$(pwd)"/"$1"

mkdir -p ${clusterdir}

for filename in _plugin/spider/_template/* ; do
  MSYS2_ARG_CONV_EXCL="*" m4 -D__clusterdir=${clusterdir} $filename > ${clusterdir}/$(basename $filename)
done

if ! detect_windows ; then
  for filename in _plugin/spider/_template/*.sh ; do
    [ -f $1/$(basename $filename) ] && chmod +x $1/$(basename $filename)
  done
fi

# do the same for enabled plugins
for plugin in $ERN_PLUGINS ; do
  [ -d ./_plugin/$plugin/cluster/ ] && for filename in ./_plugin/$plugin/cluster/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__clusterdir=${clusterdir} $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done
done


:

