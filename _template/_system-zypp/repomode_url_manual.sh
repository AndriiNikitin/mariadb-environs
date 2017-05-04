#!/bin/bash

M7VER=$1
M7MAJOR=${M7VER%\.*}

. common.sh

echo http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-$M7VER/yum/$(detect_distnameN)-$(detect_amd64)/rpms/