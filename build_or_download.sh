#!/bin/bash
set -e
[ -z "$1" ] && exit 1

if [ "$(find . -maxdepth 1 -type d -name "m$wid*" | wc -l)" -ne 1 ] ; then
  >&2 echo "one and only one folder must exist with prefix $1"
  exit 2
fi


if [ -f $1*/download.sh ] ; then
  $1*/download.sh
# cmake/build only if no build folder exists
elif ! ls $1*/build 2&>/dev/null ; then
  $1*/checkout.sh
  $1*/cmake.sh
  $1*/build.sh
fi

