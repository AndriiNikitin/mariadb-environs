#!/bin/bash
set -e

. common.sh

# extract worker prefix, e.g. m12
wwid=${1%%-*}
# extract number, e.g. 12
wid=${wwid:1:100}

port=$((3306+$wid))
workdir=$(find . -maxdepth 1 -type d -name "$wwid*" | head -1)

[[ -d $workdir ]] || ((>&2 echo "Directory must exists in format $wwid-branch") ; exit 1)

# if worker folder exists - it must be empty or have only two empty directories (those may be mapped by parent farm for docker image)
if [[ -d $workdir ]]; then
  ( [[ -d $workdir/dt && "$(ls -A $workdir/dt)" ]] \
  || [[ -d $workdir/bkup && "$(ls -A $workdir/bkup)" ]] \
  || [[ "$(ls -A $workdir | grep -E -v '(^dt$|^bkup$)')" ]] \
  ) && ((>&2 echo "Non-empty $workdir aready exists, expected unassigned worker id") ; exit 1)

  [[ $workdir =~ ($wwid-)(.*)$ ]] || ((>&2 echo "Couldn't parse format of $workdir, expected $wwid-branch") ; exit 1)

  branch=${BASH_REMATCH[2]}
fi

src=$(pwd)/_depot/m-branch/$branch

# check if source directory is not empty
if [[ ! -z $src ]] && [[ -d $src ]] && [ "$(ls -A $src)" ]; then 
  cd $src 
  srcbranch=$(git branch | grep \* | cut -d ' ' -f2) || ((>&2 echo "Cannot determine branch of directory $src") ; cd - > /dev/null; exit 1)
  cd - &> /dev/null || true

  [[ -z $branch ]] || [[ $branch == $srcbranch ]] || ((>&2 echo "Actual branch $srcbranch doesn't match $branch") ; exit 1)
fi

workdir=$(pwd)/$wwid-$branch
[[ -d $workdir ]] || mkdir $workdir
[[ -d $workdir/dt ]] || mkdir $workdir/dt
[[ -d $workdir/bkup ]] || mkdir $workdir/bkup

bld=$workdir/build

[[ -d $src ]] || mkdir -p $src || ((>&2 echo "Cannot create source directory $src") ; cd - > /dev/null; exit 1)


# detect windows like this for now
case "$(expr substr $(uname -s) 1 5)" in 
  "MINGW"|"MSYS_")
    dll=dll
    bldtype=Debug ;;
  *)
    dll=so ;;
esac

for filename in _template/m-{branch,all}/* ; do
   MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
#  m4 -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch $filename > $workdir/$(basename $filename)
done


if [[ $dll != "dll" ]]; then
  for filename in _template/m-{branch,all}/*.sh ; do
    chmod +x $workdir/$(basename $filename)
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
