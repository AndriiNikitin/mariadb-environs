#!/bin/bash

set -e
# check behavior in tar 10.1.22 
mkdir m7-10.1.22
./plant.sh m7
# _template/install_m-version_dep.sh
m7*/download.sh
m7*/gen_cnf.sh
m7*/install_db.sh
m7*/startup.sh
m7*/status.sh
m7*/sql.sh 'select version()'
# mysql --defaults-file=m7*/my.cnf -e 'select version()'
m7*/shutdown.sh

# check behavior in tar 10.1.22 
mkdir m8-10.1.22
./plant.sh m8
# _template/install_m-version_dep.sh
m8*/download.sh
m8*/gen_cnf.sh
m8*/install_db.sh
m8*/startup.sh
m8*/status.sh
m8*/sql.sh 'select version()'
# mysql --defaults-file=m8*/my.cnf -e 'select version()'
m8*/shutdown.sh

# now configure innodb plugin instead of xtradb and enable rest encryption in both environs
mkdir $(echo m7*)/config_load
mkdir $(echo m8*)/config_load
cp m7*/configure_innodb_plugin.sh m7*/configure_rest_encryption.sh m7*/config_load/
cp m8*/configure_innodb_plugin.sh m8*/configure_rest_encryption.sh m8*/config_load/
m7*/gen_cnf.sh
m8*/gen_cnf.sh
m7*/startup.sh --log-bin
m7*/status.sh
m8*/startup.sh --log-bin
m8*/status.sh

# now try to setup circular replication
m7*/replicate.sh m8
m8*/replicate.sh m7

# test that replication works both ways
m7*/sql.sh "create database d1; create table d1.t select 1"
sleep 1
m8*/sql.sh 'insert into d1.t select 2'
sleep 1
# mysql --defaults-file=m7*/my.cnf -e 'select version(); select from d1.t'
# mysql --defaults-file=m8*/my.cnf -e 'select version(); select from d1.t'
m7*/sql.sh 'select version(); select * from d1.t'
m8*/sql.sh 'select version(); select * from d1.t'