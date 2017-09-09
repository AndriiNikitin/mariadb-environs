#!/bin/bash
[[ -d __workdir/plugin ]] || mkdir __workdir/plugin
[[ -f __workdir/plugin/ha_innodb.__dll ]] || ln -s __blddir/storage/innobase/__bldtype/ha_innodb.__dll __workdir/plugin/ha_innodb.__dll

cat >> __workdir/mysqldextra.cnf <<EOL
ignore_builtin_innodb
plugin_load_add=ha_innodb
EOL
