#!/bin/bash
bash mysql_install_db --defaults-file=__workdir/my.cnf --user=$(whoami) --force