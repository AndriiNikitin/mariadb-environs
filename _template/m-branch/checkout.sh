#!/bin/bash
[[ -d __srcdir ]] || mkdir -p __srcdir
[[ -d __blddir ]] || mkdir __blddir

cd __srcdir
git clone --depth=1 http://github.com/MariaDB/server -b __branch .

cd __srcdir
git pull
