#!/bin/bash
[ -f common.sh ] && source common.sh

[[ -d __blddir ]] || mkdir __blddir

( cd __blddir &&
cmake __srcdir -DBUILD_CONFIG=mysql_release -DWITH_READLINE=1 )
