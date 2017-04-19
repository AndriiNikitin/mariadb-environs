#!/bin/bash
# check if folder exists - and redirect to corresponding subscript to fill worker files
set -e

. common.sh

[ -z "$1" ] && exit 1

wwid=${1:0:2}
wid=${wwid:1:2}
wtype=${wwid:0:1}

workdir=$(find . -maxdepth 1 -type d -name "$wwid*" | head -1)

# check that only one or none directory exists
[ $(find . -maxdepth 1 -path ./$wwid\* | wc -l) -le 1 ] || { >&2 echo "Found several directories matching $wwid*" ; exit 1; }

[[ -d $workdir ]] || { >&2 echo "Empty folder of corresponding format must exist, cannot find $wwid*" ; exit 1; }


[[ $workdir =~ ($wwid-)([^\@]+)(\@.+)?$ ]] || { >&2 echo "Couldn't parse format of $workdir, expected $wwid-tag1[@image]" ; exit 1; }

[[ -z ${BASH_REMATCH[3]} ]] || image="@image"

branch=${BASH_REMATCH[2]}

declare -A version_format

version_format['m']="([1-9][0-9]?)(\.)([0-9])(\.)([1-9][0-9]?)"
version_format['x']="([1-9]?)(\.)([0-9])(\.)([1-9]?)"

plant_script=""

if [[ "$branch" == system ]]; then 
  plant_script=_template/plant_$wtype-system$image.sh
elif [[ "$branch" == system2 ]]; then
  plant_script=_template/plant_$wtype-system2$image.sh
elif [[ "$branch" =~ ${version_format[$wtype]} ]]; then
  plant_script=_template/plant_$wtype-version$image.sh
else
  plant_script=_template/plant_$wtype-branch$image.sh
fi

# if script not found - try to find in enabled plugins
if [ ! -f $plant_script ] ; then
  for plugin in $ERN_PLUGINS ; do
    [ -f "./_plugin/$plugin/$(basename $plant_script)" ] && plant_script=./_plugin/$plugin/$(basename $plant_script)
  done
fi

if [ ! -f $plant_script ] ; then
  >&2 echo "Couldn't find plant script for $wtype-$branch$image.sh" ; exit 1;
fi

$plant_script $@