#!/bin/bash

keyfile=/var/lib/mysql/k

echo "1;770A8A65DA156D24EE2A093277530142" > $keyfile.txt &&
  echo "18;F5502320F8429037B8DAEF761B189D12F5502320F8429037B8DAEF761B189D12" >> $keyfile.txt &&
  openssl enc -aes-256-cbc -md sha1 -k "ssecret" -in $keyfile.txt -out $keyfile.enc || { echo "Cannot generate key file" >&2 ;  exit 4; }

cat >> /etc/mysqldextra.cnf <<EOL
plugin_load_add=file_key_management
file_key_management_encryption_algorithm=aes_cbc
file_key_management_filename=$keyfile.enc
file_key_management_filekey=ssecret
innodb-encrypt-log=ON
innodb-encryption-rotate-key-age=2
innodb-encryption-threads=4
innodb-tablespaces-encryption
innodb-encrypt-tables=FORCE
EOL