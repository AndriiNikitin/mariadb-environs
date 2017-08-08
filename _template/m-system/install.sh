#!/bin/bash

. __workdir/../common.sh

[[ $1 =~ ([1-9][0-9]?\.[0-9])(.)? ]] && mode=repo${BASH_REMATCH[2]} && M7VER=${BASH_REMATCH[1]}
[[ $1 =~ ([1-9][0-9]?\.[0-9]\.[0-9][0-9]?)(.)? ]] && mode=manual${BASH_REMATCH[2]} && M7VER=${BASH_REMATCH[1]}

if [[ $mode =~ repo* ]] ; then
   M7MAJOR=$M7VER
else
   M7MAJOR=${M7VER%\.*}
fi

[ ! -z "$M7VER" ] || { echo "Expected MariaDB version as first parameter, e.g. 10.0 or 10.1e; got ($M7VER)";  exit 2; }

# remove old repos if exist
for SCRIPT in __workdir/../_system/repomode_clean*.sh
do
  $SCRIPT
done

set -e

if [ -f __workdir/../_system/repomode_configure_$mode.sh ] ; then
  __workdir/../_system/repomode_configure_$mode.sh $M7MAJOR
else
  __workdir/../_system/repomode_configure.sh $M7MAJOR
fi

__workdir/../_system/repomode_install_${mode%?}*.sh $M7VER ${mode} $2
