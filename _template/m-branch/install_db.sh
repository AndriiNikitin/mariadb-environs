#!/bin/bash
bash __srcdir/scripts/mysql_install_db.sh --defaults-file=__workdir/my.cnf --user=$(whoami) --builddir=__blddir --srcdir=__srcdir --force
