#!/bin/bash

. common.sh

if [[ "$(detect_yum)" == apt ]]; then
  libarchive=libarchive13
  (cat /etc/*release | grep -qE "wheezy|Precise Pangolin") && libarchive=libarchive12 || :

  apt-get update && apt-get install -y --no-install-recommends git bison chrpath cmake debhelper dh-apparmor dpatch libaio-dev libboost-dev libjudy-dev\
    libkrb5-dev libncurses5-dev libpam0g-dev libreadline-gplv2-dev libssl-dev lsb-release perl po-debconf psmisc zlib1g-dev\
    $libarchive libarchive-dev libjemalloc-dev gawk hardening-wrapper wget vim cmake make g++ m4 ca-certificates libxml2-dev default-jdk sudo

  which gmake || ln -s /usr/bin/make /usr/bin/gmake

  apt-get clean
 
elif [[ "$(detect_yum)" == yum ]]; then
  yum install -y git cmake make gcc-c++ ncurses-devel bison zlib zlib-devel zlib-static openssl vim findutils sudo
# TODO this is needed for mtr on centos 7 yum install 'perl(Data::Dumper)'
else 
  echo "Cannot determine distro" 1>&2; exit 1;
fi
