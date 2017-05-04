#!/bin/bash
cat >> __workdir/mysqldextra.cnf <<EOL
ignore_builtin_innodb
plugin_load_add=ha_innodb
EOL
