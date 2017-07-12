#!/bin/bash
mysqld_safe --skip-syslog "$@" & 
__workdir/wait_respond.sh
