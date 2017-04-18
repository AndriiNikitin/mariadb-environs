#!/bin/bash

M7MAJOR=$1

# todo !! test special characters in passwords
M7ROOTPWD=
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password password '"$M7ROOTPWD"
debconf-set-selections <<< 'mariadb-server-$M7MAJOR mysql-server/root_password_again password '"$M7ROOTPWD"

apt-get install -y mariadb-server-$M7MAJOR