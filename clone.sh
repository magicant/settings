#!/bin/sh

# https://raw.githubusercontent.com/magicant/settings/master/clone.sh | sh

set -Ceu

if [ "$PWD" != ~/.settings ] && [ "${1-}" != -f ]; then
  printf 'Use -f to run in a non-standard directory.\n'
  exit 1
fi

set -x

git init
git svn init --prefix=origin/ https://subversion.assembla.com/svn/magicant/settings
git remote add github https://github.com/magicant/settings.git
git config remote.github.pushurl git@github.com:magicant/settings.git
git config remote.github.push refs/remotes/origin/git-svn:refs/heads/master
git remote update github
git update-ref refs/remotes/origin/git-svn refs/remotes/github/master
git remote set-head github master
git remote set-head origin git-svn
git reset --hard origin
git svn rebase
git svn show-ignore >> .git/info/exclude
