#!/bin/bash

. common.sh

if [[ "$(detect_yum)" == apt ]]; then
  apt-get update && apt-get install -y --no-install-recommends wget vim m4 ca-certificates openssl libaio1 
#     galera-3 lsof # TODO these are needed for galera only
  apt-get clean
elif [[ "$(detect_yum)" == yum ]]; then
  yum install -y wget openssl vim m4 libaio findutils
else 
  echo "Cannot determine distro" 1>&2; exit 1;
fi
