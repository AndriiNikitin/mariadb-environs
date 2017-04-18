#!/bin/bash
mysqld_safe --loose-syslog=0 "$@" & 
__workdir/wait_respond.sh
