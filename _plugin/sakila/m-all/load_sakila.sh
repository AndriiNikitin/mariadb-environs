#!/bin/bash

FILE=http://downloads.mysql.com/docs/sakila-db.tar.gz

mkdir -p __workdir/../_depot/sakila

(
cd __workdir/../_depot/sakila
[[ -f $(basename $FILE) ]] || { wget -nc $FILE && tar -zxf $(basename $FILE) --strip 1; }
)

__workdir/sql.sh 'source __workdir/../_depot/sakila/sakila-schema.sql' && \
  __workdir/sql.sh 'source __workdir/../_depot/sakila/sakila-data.sql'
