#!/bin/sh

# $1 = pathname of target
# $2 = pathname of new symlink
# $3 = user-friendly representation of $2, optional
# $4 = user-friendly representation of $1, optional
makelink () {
    if [ -L "$2" ]; then
        if
            if [ -d "$1" ]; then
                test "$(cd -P -- "$1" && pwd -P)" = "$(cd -P -- "$2" && pwd -P)"
            else
                diff -q -- "$1" "$2"
            fi 2>/dev/null
        then
            echo "Symbolic link ${3:-$2} already exists"
        else
            echo "Symbolic link ${3:-$2} seems broken"
        fi
        return
    fi
    if [ -e "$2" ]; then
        if [ -e "$2.bak" ]; then
            echo "File ${3:-$2} is not symlink and backup file ${3:-$2}.bak already exists"
            return
        fi
        if mv -- "$2" "$2.bak"; then
            echo "Moved ${3:-$2} to ${3:-$2}.bak"
        else
            return # non-zero exit status
        fi
    fi
    if mkdir -p "$(dirname -- "$2")" && bin/relpath -s -- "$1" "$2"; then
        echo "${3:-$2}" "->" "${4:-$1}"
    else
        return # non-zero exit status
    fi
}

# $1 = pathname of target, relative to $PWD or absolute
# $2 = pathname of new symlink, relative to $HOME
# $3 = user-friendly representation of $1, optional
makelinkhome() {
    makelink "$1" "${HOME%/}/$2" "~/$2" "${3:-$1}"
}

set -Ceu
cd -- "$(dirname -- "$0")"
echo Home directory is "$HOME"
echo Settings directory is "$PWD"

makelinkhome bashrc .bashrc
for file in .bash_profile .bash_login
do
    if [ -e "${HOME%/}/$file" ]; then
        if [ -e "${HOME%/}/$file.bak" ]; then
            echo "WARNING: ~/$file exists."
        elif mv -- "${HOME%/}/$file" "${HOME%/}/$file.bak"; then
            echo "Moved ${HOME%/}/$file to ${HOME%/}/$file.bak"
        fi
    fi
done
makelinkhome byobu .byobu
makelinkhome colordiffrc .colordiffrc
if command -v dircolors >/dev/null 2>&1; then
    if TERM=xterm dircolors dircolors >/dev/null 2>&1; then
        makelinkhome dircolors .dircolors
    else
        echo The dircolors command is too old to support your dircolors file
        echo Use the makedircolors script to fix it
    fi
fi
if [ -e "$HOME/.gitconfig" ]; then
    echo "File ~/.gitconfig already exists"
else
    {
        echo '[include]'
        echo "  path = $(bin/relpath -- gitconfig "$HOME/.gitconfig")"
    } >"$HOME/.gitconfig"
    echo "Created ~/.gitconfig"
fi
makelinkhome inputrc .inputrc
makelinkhome lesskey .lesskey
if command -v lesskey >/dev/null 2>&1; then
    if lesskey; then
        echo updated .less
    fi
fi
makelinkhome minttyrc .minttyrc
if echo q | top -V 2>/dev/null | grep -q procps; then
    makelinkhome toprc .toprc
fi
makelinkhome vimrc .vimrc
makelinkhome vim .vim
makelinkhome yashrc .yashrc
makelinkhome zshrc .zshrc
makelinkhome "${HOME%/}/.profile" .yash_profile "~/.profile"

if [ -L ~/.yash_history ]; then
    echo "Symbolic link ~/.yash_history already exists"
elif [ -e ~/.yash_history ]; then
    echo "File ~/.yash_history already exists"
elif ln -s .local/state/yash/history ~/.yash_history; then
    echo "Symbolic link ~/.yash_history -> .local/state/yash/history created"
else
    exit
fi

# Install my own "which" if the system-provided "which" does not support the -a
# option
if [ "$(PATH=$PATH:$PATH which -a which 2>/dev/null)" = \
        "$(which -a which 2>/dev/null)" ]; then
    makelink libexec/which bin/which
fi

# Install my own "pbcopy" & "pbpaste" if the system does not provide them.
if command -v pbcopy >/dev/null 2>&1; then
    echo "pbcopy command already exists"
else
    makelink libexec/pbcopy bin/pbcopy
fi
if command -v pbpaste >/dev/null 2>&1; then
    echo "pbpaste command already exists"
else
    makelink libexec/pbpaste bin/pbpaste
fi

if command -v vim >/dev/null 2>&1; then
    vim/setup.sh
    if command -v gvim >/dev/null 2>&1; then
        makelink bin/vimless bin/gvimless
    fi
fi

mkdir -m go-w -p "${HOME%/}/.ssh"
if [ -e "${HOME%/}/.ssh/config" ]; then
    echo "~/.ssh/config already exists"
else
    (umask go-w && cp ssh_config "${HOME%/}/.ssh/config")
    echo "Created ~/.ssh/config"
fi

for file in .profile .hgrc
do
    if ! [ -r "${HOME%/}/$file" ]; then
        echo "WARNING: ~/$file does not exist or is not readable."
    fi
done
for file in "$HOME" "${HOME%/}/.ssh"
do
    if [ "$(ls -dgo -- "$file" | cut -c 6)" != - ]; then
        echo "WARNING: $file is group-writable."
    fi
    if [ "$(ls -dgo -- "$file" | cut -c 9)" != - ]; then
        echo "WARNING: $file is world-writable."
    fi
done

# vim: ft=sh et sw=4 sts=4
