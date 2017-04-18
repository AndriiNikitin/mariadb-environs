#!/bin/bash
sed -i.bkp -E "/(mariadb\/repo\/)([1-9][0-9]?\.[0-9])/d" /etc/apt/sources.list || :