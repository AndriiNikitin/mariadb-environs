#!/bin/bash

# assign arguments in reverse order
((i=$#))

[[ "$i" -ge 1 ]] && mid=${!i} && ((i--))

[[ $mid =~ [0-9] ]] || { echo "Expected MariaDB environ id as last parameter, got ($mid)" 1>&2; exit 1; }

set -x
set -e

cd m${mid}*
./cleanup.sh

./gen_cnf.sh
./configure_aws_encryption.sh alias/test1
./install_db.sh
./startup.sh
./sql.sh 'create table test.t1(a int, b varchar(32))'
./sql.sh 'insert into test.t1 select 1, "testing"'
./sql.sh 'select * from test.t1'
./sql.sh 'show variables like "aws_key_management_master_key_id"'
./sql.sh 'select * from information_schema.plugins where plugin_type="encryption"'

./shutdown.sh

./configure_aws_encryption.sh alias/mdbe-enc-ms
./startup.sh
./sql.sh 'select * from test.t1'
./sql.sh 'show variables like "aws_key_management_master_key_id"'
./sql.sh 'select * from information_schema.plugins where plugin_type="encryption"'

