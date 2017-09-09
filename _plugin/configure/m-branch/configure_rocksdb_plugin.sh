#!/bin/bash
[[ -d __workdir/plugin ]] || mkdir __workdir/plugin
[[ -f __workdir/plugin/ha_rocksdb.__dll ]] || ln -s __workdir/storage/rocksdb/ha_rocksdb.__dll __workdir/plugin/ha_rocksdb.__dll

cat >> __workdir/mysqldextra.cnf <<EOL
plugin_load_add=ha_rocksdb
EOL
