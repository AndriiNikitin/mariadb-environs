#!/bin/bash
# use this hack to allow mysqld service start on debian docker image
# check if file contains only one line of code (excluding comments)
if [ "$(grep -v "^\#" /usr/sbin/policy-rc.d | grep . | wc -l)" == "1" ] && [ "`tail -n 1 /usr/sbin/policy-rc.d`" == "exit 101" ] 
then
  echo '#!/bin/sh' > /usr/sbin/policy-rc.d
  echo 'exit 0' >> /usr/sbin/policy-rc.d
fi
