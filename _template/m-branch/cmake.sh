#!/bin/bash
[ -f common.sh ] && source common.sh

[[ -d __blddir ]] || mkdir __blddir

cd __blddir
cmake __srcdir ${ERN_M_CMAKE_FLAGS:-\-DWITH_LIBARCHIVE=1 -DPLUGIN_TOKUDB=NO}
