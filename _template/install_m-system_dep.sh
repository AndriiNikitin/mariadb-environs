#!/bin/bash

. common.sh

if [[ "$(detect_yum)" == apt ]]; then
  apt-get update && apt-get install -y --no-install-recommends wget vim m4 ca-certificates curl libodbc1  libxml2 libjudydebian1 
#  adduser galera-3 gawk iproute init-system-helpers libaio1 libclass-isa-perl libdbd-mysql-perl \
#  libdbi-perl libgdbm3 libhtml-template-perl libjemalloc1 libpopt0 \
#  libreadline5 libsigsegv2 libswitch-perl libwrap0 lsof perl perl-modules \
#  psmisc rsync socat tcpd

  apt-get clean
elif [[ "$(detect_yum)" == yum ]]; then
  yum install -y openssl vim ca-certificates m4 wget curl findutils
elif [[ "$(detect_yum)" == zypp ]]; then
  zypper install -y openssl vim ca-certificates m4 wget curl findutils
else 
  echo "Cannot determine distro" 1>&2; exit 1;
fi
