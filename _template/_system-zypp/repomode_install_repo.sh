#!/bin/bash

# # TODO upgrade may fail without this - troubleshoot
# yum --showduplicates list MariaDB-server | expand

zypper install -y MariaDB-server MariaDB-client

[ -z $3 ] || zypper install -y MariaDB-$3