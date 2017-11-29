#!/bin/bash
[[ -d __srcdir ]] || mkdir -p __srcdir
[[ -d __blddir ]] || mkdir __blddir

git clone --depth=1 http://github.com/MariaDB/server -b __branch __srcdir

