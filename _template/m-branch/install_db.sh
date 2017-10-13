#!/bin/bash
# bash __blddir/scripts/mysql_install_db --defaults-file=__workdir/my.cnf --user=$(whoami) --builddir=__blddir --srcdir=__srcdir --force
$(realpath __blddir/scripts/mysql_install_db) --defaults-file=__workdir/my.cnf --user=$(whoami) --builddir=$(realpath __blddir) --srcdir=$(realpath __srcdir) --force
