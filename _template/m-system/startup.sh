#!/bin/bash
# use which to work around MDEV-13978 mysqld_safe may incorrectly detect basedir when started as script
sudo $(which mysqld_safe) --skip-syslog "$@" &
__workdir/wait_respond.sh && sudo mysql -e 'create database if not exists test'
