#!/bin/bash
set -e
[ ! -z "$1" ] || (
  >&2 echo "expected environ id as parameter"
  exit 1
)
if [ "$(find . -maxdepth 1 -type d -name "$1*" | wc -l)" -ne 1 ] ; then
  >&2 echo "one and only one folder must exist with prefix $1"
  exit 2
fi


if [ -f $1*/download.sh ] ; then
  $1*/download.sh
# cmake/build only if no build folder exists
elif [ -f $1*/build_if_needed.sh ] ; then
  $1*/build_if_needed.sh
else
  :
fi

