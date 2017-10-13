#!/bin/bash
set -e

. common.sh

# extract worker prefix, e.g. m12
wwid=${1%%-*}
# extract number, e.g. 12
wid=${wwid:1:100}

port=$((3306+$wid))

workdir=$(find . -maxdepth 1 -type d -name "$wwid*" | head -1)
[[ -d $workdir ]] || {  >&2 echo "Directory must exists in format $wwid-branch"; exit 1; }


if [ "$#" -gt 1 ] ; then
# [ ! -z "$2" ] || { >&2 echo "Expected source directory as second parameter"; exit 2; }
# if ls ${wwid}* 1> /dev/null 2>&1; then
#   >&2 echo "Environ $wwid already has directory - expected free environ id"; 
#    exit 2;
#  fi
  src=$2
  bld=${3-$src}

  # try to determime branch, if it is empty - no git scrips should be generated
# /*disabled for now*/  branch=$(cd $src && git branch 2>/dev/null | grep \* | cut -d ' ' -f2 )
else
  # if worker folder exists - it must be empty or have only two empty directories (those may be mapped by parent farm for docker image)
  if [[ -d $workdir ]]; then
    ( [[ -d $workdir/dt && "$(ls -A $workdir/dt)" ]] \
    || [[ -d $workdir/bkup && "$(ls -A $workdir/bkup)" ]] \
    || [[ "$(ls -A $workdir | grep -E -v '(^dt$|^bkup$)')" ]] \
    ) && {>&2 echo "Non-empty $workdir aready exists, expected unassigned worker id"; exit 1;}
  fi
fi

[[ $workdir =~ ($wwid-)(.*)$ ]] || {>&2 echo "Couldn't parse format of $workdir, expected $wwid-branch"; exit 1;}

branch=${BASH_REMATCH[2]}

workdir="$(pwd)/$wwid"
[ -z "$branch" ] || workdir="$workdir-$branch"

[[ -d "$workdir" ]] || mkdir "$workdir"
[[ -d "$workdir/dt" ]] || mkdir "$workdir/dt"
[[ -d "$workdir/bkup" ]] || mkdir "$workdir/bkup"

[ ! -z "$src" ] || {
  src="${workdir}/src"
  mkdir -p _depot/m-branch
  [ -e _depot/m-branch/$(basename "$workdir")-src ] || mkdir -p _depot/m-branch/$(basename "$workdir")-src
  ln -s $(pwd)/_depot/m-branch/$(basename "$workdir")-src "$workdir"/src
}

[ ! -z "$bld" ] || {
  bld="${workdir}/bld"
  mkdir -p _depot/m-branch
  [ -e _depot/m-branch/$(basename "$workdir")-bld ] || mkdir -p _depot/m-branch/$(basename "$workdir")-bld
  ln -s $(pwd)/_depot/m-branch/$(basename "$workdir")-bld "$workdir"/bld
}

[ -e "$src" ] || mkdir -p "$src" || {>&2 echo "Cannot create source directory $src" ; exit 1;}

# detect windows like this for now
case "$(expr substr $(uname -s) 1 5)" in 
  "MINGW"|"MSYS_")
    dll=dll
    bldtype=Debug ;;
  *)
    dll=so ;;
esac

for filename in _template/m-{branch,all}/* ; do
  # generate scripts with __branch only if $branch is not empty
  if [ -z "$branch" ] && grep -q __branch $filename ; then
    :
  else
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
  fi
done


if [[ $dll != "dll" ]]; then
  for filename in _template/m-{branch,all}/*.sh ; do
    [ -f $workdir/$(basename $filename) ] && chmod +x $workdir/$(basename $filename)
  done
fi

# do the same for enabled plugins
for plugin in $ERN_PLUGINS ; do
  [ -d ./_plugin/$plugin/m-branch/ ] && for filename in ./_plugin/$plugin/m-branch/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done
  [ -d ./_plugin/$plugin/m-all/ ] && for filename in ./_plugin/$plugin/m-all/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done
done

:

