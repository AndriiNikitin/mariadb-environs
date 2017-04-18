#!/bin/bash
cat >> __workdir/my.cnf <<EOL
ignore_builtin_innodb
plugin_load_add=ha_innodb
EOL