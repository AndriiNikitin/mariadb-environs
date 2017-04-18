#!/bin/bash
__workdir/kill9.sh

[ -f __workdir/my.cnf ] && mysqladmin --defaults-file=__workdir/my.cnf shutdown && sleep 5

rm -rf __datadir/*
rm -f __workdir/my.cnf
