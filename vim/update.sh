#!/bin/sh

# Updates plugins that are installed as Git repositories.

set -Ceu
umask u+rwx
unset CDPATH
cd -P -- "$(dirname -- "$0")"

clone_dir='pack/_/start'

mkdir -p "$clone_dir"
cd "$clone_dir"

update() (
    printf '===== %s\n' "$1"
    name="$1"
    name="${name%/}"
    name="${name%.git}"
    name="${name##*/}"
    if ! [ -d "$name" ]; then
        git clone "$1"
        cd -- "$name"
    else
        cd -- "$name"
        if git diff --quiet HEAD; then
            git pull --ff-only
        else
            printf 'skipping unclean repository %s\n' "$name" >&2
        fi
    fi
    if [ -d doc ] &&
            ! git ls-files --error-unmatch doc/tags >/dev/null 2>&1; then
        vim -e -s -u NONE -c 'helptags doc' -c q
    fi
)

update https://github.com/keith/swift.vim.git
update https://github.com/neovimhaskell/haskell-vim.git
update https://github.com/tpope/vim-commentary.git
update https://github.com/tpope/vim-fugitive.git
update https://github.com/tpope/vim-repeat.git
update https://github.com/tpope/vim-surround.git
update https://github.com/udalov/kotlin-vim.git
update https://github.com/vim-scripts/AnsiEsc.vim.git

# vim: ft=sh et sw=4 sts=4
