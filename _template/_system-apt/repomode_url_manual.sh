#!/bin/bash

M7VER=$1
M7MAJOR=${M7VER%\.*}

. common.sh

echo http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-$M7VER/repo/$(detect_distname)/pool/main/m/mariadb-$M7MAJOR/