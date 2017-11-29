#!/bin/bash
set -e
mkdir -p __workdir/../_depot/m-branch
[ -d __workdir/../_depot/m-branch/repo ] || git clone http://github.com/MariaDB/server __workdir/../_depot/m-branch/repo
mkdir -p __srcdir
mkdir -p __workdir/../_depot/m-branch/"$(basename __workdir)"
ln -sf __workdir/../_depot/m-branch/"$(basename __workdir)" __blddir

if [ ! -e __srcdir/.git ] ; then
  git --git-dir=__workdir/../_depot/m-branch/repo/.git worktree add __srcdir origin/__branch
fi
