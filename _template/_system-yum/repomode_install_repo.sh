#!/bin/bash

# # TODO upgrade may fail without this - troubleshoot
# yum --showduplicates list MariaDB-server | expand

yum -y install MariaDB-server MariaDB-client
