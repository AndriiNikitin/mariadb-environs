#!/bin/bash

M7VER=$1
M7MAJOR=${M7VER%\.*}
mode=$2
# todo !! test special characters in passwords
M7ROOTPWD=
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password password '"$M7ROOTPWD"
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password_again password '"$M7ROOTPWD"

. common.sh

declare -r DISTCODE=$(detect_distcode)

FOLDER=$(_system/repomode_url_${mode}.sh $M7VER)
DESTINATION=_depot/m-system/$DISTCODE/$M7VER$mode


PKGLIST="libmysqlclient18 libmariadbclient18 mysql-common mariadb-common \
  mariadb-client-core-$M7MAJOR mariadb-client-$M7MAJOR mariadb-server-core-$M7MAJOR \
  mariadb-server-$M7MAJOR"

PKGARRAY=($PKGLIST)

wget -V > /dev/null || apt-get -y install wget
grep -qP . /etc/*release &>/dev/null || apt-get install libpcre3

mkdir -p $DESTINATION

download () {
        PACKAGE=$1

        if [[ $PACKAGE == *common* ]]; then
                FILE=$PACKAGE\_$M7VER+maria-1~$DISTCODE\_all.deb;
        else
                FILE=$PACKAGE\_$M7VER+maria-1~$DISTCODE\_$(detect_amd64).deb;
        fi

        [[ -f $DESTINATION/$FILE ]] || (wget -nv -nc $FOLDER$FILE -P $DESTINATION || { err=$? ; echo "Error ("$err") downloading file: "$FOLDER$FILE 1>&2 ; exit $err; })
}

for i in ${PKGARRAY[@]}
do
  download $i
done

dpkg -i $DESTINATION/*common*$M7VER*$DISTCODE*.deb
dpkg -i $DESTINATION/lib*client*$M7VER*$DISTCODE*.deb

# this will install only dependancies, excluding upgrades and mysql/mariadb packages
# need derty hack with perl regexp below to actually include perl dependencies which have mysql in it
apt-install-depends() {
      apt-get install -s $@ \
    | sed -n \
      -e "/^Inst $pkg /d" \
      -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
    | grep -v -P '(?=^(?:(?!perl).)*$).*mysql.*' \
    | grep -v mariadb \
    | grep -v updates \
    | xargs apt-get -y --no-install-recommends install
}

apt-install-depends ${PKGLIST[@]}

dpkg -i $DESTINATION/*$M7VER*$DISTCODE*.deb
