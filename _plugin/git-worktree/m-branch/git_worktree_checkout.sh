#!/bin/bash
__workdir/git_worktree_add.sh && \
  git --git-dir=__srcdir/.git checkout __branch
