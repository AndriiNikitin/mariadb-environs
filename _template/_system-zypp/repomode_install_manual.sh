#!/bin/bash

M7VER=$1
M7MAJOR=${M7VER%\.*}
mode=$2

. common.sh

FOLDER=$(_system/repomode_url_${mode}.sh $M7VER)
DESTINATION=_depot/m-system/$(detect_distnameN)/$M7VER$mode

PKGLIST="common compat shared client server"
PKGARRAY=($PKGLIST)
wget -V > /dev/null || yum -y install wget
mkdir -p $DESTINATION

download () {
        FILE=MariaDB-$M7VER-$(detect_distnameN)-$(detect_x86)-$1.rpm

        [[ -f $DESTINATION/$FILE ]] || (wget -nv -nc $FOLDER$FILE -P $DESTINATION || { err=$? ; echo "Error ("$err") downloading file: "$FOLDER$FILE 1>&2 ; return $err; })
}


for i in ${PKGARRAY[@]}
do
   retry 5 download $i
done

zypper install -y $DESTINATION/*.rpm

