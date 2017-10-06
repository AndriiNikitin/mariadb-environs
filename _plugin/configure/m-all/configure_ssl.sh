#!/bin/bash
set -e
# we let all nodes communicate with each other, so use common ca in ../_depot
cadir=__workdir/../_depot
ssldir=__workdir/ssl

subj='/C=NL/ST=Zuid Holland/L=Rotterdam/O=Sparkling Network/OU=IT Department/CN'

mkdir -p $cadir

if [ ! -e $cadir/ca.pem ] ; then
  openssl genrsa 2048 > $cadir/ca-key.pem
  openssl req -new -x509 -nodes -days 3600 -key $cadir/ca-key.pem -out $cadir/ca.pem -subj "${subj}=farm"
fi

mkdir -p $ssldir

openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/server-key.pem -out $ssldir/server-req.pem -subj "${subj}=server-__wid"
openssl rsa -in $ssldir/server-key.pem -out $ssldir/server-key.pem
openssl x509 -req -in $ssldir/server-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/server-cert.pem"

openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/client-key.pem -out $ssldir/client-req.pem -subj "${subj}=client-__wid"
openssl rsa -in $ssldir/client-key.pem -out $ssldir/client-key.pem
openssl x509 -req -in $ssldir/client-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/client-cert.pem"

(
cat <<EOF
[client]
ssl-ca=$cadir/ca.pem
ssl-cert=$ssldir/client-cert.pem
ssl-key=$ssldir/client-key.pem

[mysqld]
ssl-ca=$cadir/ca.pem
ssl-cert=$ssldir/server-cert.pem
ssl-key=$ssldir/server-key.pem

loose-wsrep_provider_options="socket.ssl_key=$ssldir/server-key.pem;socket.ssl_cert=$ssldir/server-cert.pem;socket.ssl_ca=$cadir/ca.pem"
EOF
) >> __workdir/mysqldextra.cnf

