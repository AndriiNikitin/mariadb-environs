#!/bin/bash

. common.sh

if [[ "$(detect_yum)" == apt ]]; then

  apt-get update && apt-get install -y --no-install-recommends sudo
elif [[ "$(detect_yum)" == yum ]]; then
  yum install -y sudo
else 
  echo "Cannot determine distro" 1>&2; exit 1;
fi
