#!/bin/bash

. common.sh

if [[ "$(detect_yum)" == apt ]]; then
  # todo remove galera3, troubleshoot dependencies
  apt-get update && apt-get install -y --no-install-recommends wget vim m4 ca-certificates
  apt-get clean
elif [[ "$(detect_yum)" == yum ]]; then
  yum install -y openssl vim ca-certificates m4 wget
else 
  echo "Cannot determine distro" 1>&2; exit 1;
fi
