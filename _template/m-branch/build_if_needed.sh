#!/bin/bash

set -e

# __blddir may be link
[ -e "__blddir" ] || mkdir -p "__blddir"
[ -e "__srcdir"/CMakeLists.txt ] || "__workdir"/clone.sh

[ -f "__blddir"/Makefile ] || "__workdir"/cmake.sh
"__workdir"/build.sh
