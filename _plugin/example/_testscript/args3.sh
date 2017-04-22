#!/bin/bash

if [ ${#@} -ne 3 ] ; then
 >&2 echo "Expected three arguments, got ${#@}"
 [ -z "$1" ] || >&2 echo "1: ($1)"
 [ -z "$2" ] || >&2 echo "2: ($2)"
 [ -z "$3" ] || >&2 echo "3: ($3)"
 [ -z "$4" ] || >&2 echo "4: ($4)"
 exit 2
fi
