#!/bin/bash

M7MAJOR=$1

. common.sh

  cat > /etc/zypp/repos.d/mariadb$M7MAJOR.repo <<EOL
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/$M7MAJOR/$(detect_distname)$(detect_distver)-$(detect_amd64)
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOL

rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
