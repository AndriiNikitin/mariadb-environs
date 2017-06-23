#!/bin/bash

. __workdir/../common.sh

cat >> __workdir/mysqldextra.cnf <<EOL
plugin-load-add = aws_key_management
aws-key-management
aws-key-management-master-key-id = ${1-${ERN_AWS_KEY_MANAGEMENT_MASTER_KEY-alias/test1}}
aws-key-management-region = us-east-1
innodb-encrypt-log=ON
innodb-encryption-rotate-key-age=2
innodb-encryption-threads=4
innodb-tablespaces-encryption
innodb-encrypt-tables=FORCE
EOL
