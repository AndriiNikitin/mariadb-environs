#!/bin/bash

# # TODO upgrade may fail without this - troubleshoot
# yum --showduplicates list MariaDB-server | expand

yum -y install MariaDB-server MariaDB-client

[ -z $3 ] || yum -y install MariaDB-$3