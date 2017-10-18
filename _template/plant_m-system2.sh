#!/bin/bash
set -e

. common.sh

# extract worker prefix, e.g. m12
wwid=${1%%-*}
# extract number, e.g. 12
wid=${wwid:1:100}

port=$((3306+$wid))

workdir=$(find . -maxdepth 1 -type d -name "$wwid-system2" | head -1)

[[ -d $workdir ]] || ((>&2 echo "Directory must exists in format $wwid-system") ; exit 1)

workdir=$(pwd)/$wwid-system2

dll=so
detect_windows && dll=dll 

for filename in ./_template/m-{system2,all}/* ; do
   MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__wwid=$wwid -D__workdir=$workdir -D__port=$port -D__dll=$dll -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
done

detect_windows || for filename in _template/m-{system2,all}/*.sh ; do
    chmod +x $workdir/$(basename $filename)
done

yum=$(detect_yum)

# add other methods detecting distro here if needed
mkdir -p ./_system
cp ./_template/_system-$yum/* ./_system/

# do the same for enabled plugins
for plugin in $ERN_PLUGINS ; do
  [ -d ./_plugin/$plugin/m-system2/ ] && for filename in ./_plugin/$plugin/m-system2/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__wwid=$wwid -D__workdir=$workdir -D__port=$port -D__dll=$dll -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done

  [ -d ./_plugin/$plugin/m-all/ ] && for filename in ./_plugin/$plugin/m-all/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__wwid=$wwid -D__workdir=$workdir -D__port=$port -D__dll=$dll -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done

#  find . -path "./_plugin/$plugin/m-system/*.sh" -exec m4 -D__workdir=$workdir -D__dll=$dll {} \> $workdir/$(basename {}) \;
  find . -path "./_plugin/$plugin/_system-$yum/*" -exec cp {} ./_system/ \;
done

:
