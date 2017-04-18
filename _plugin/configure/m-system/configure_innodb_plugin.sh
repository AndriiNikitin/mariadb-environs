#!/bin/bash

cat >> /etc/mysqldextra.cnf <<EOL
ignore_builtin_innodb
plugin_load_add=ha_innodb
EOL
