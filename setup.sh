#!/bin/sh

makelink () {
	case $PWD in
		${HOME%/}/*)
			prefix="${PWD#${HOME%/}/}"
			t="$(dirname "$2")"
			until [ x"$t" = x"." ]; do
				prefix="../$prefix"
				t="$(dirname "$t")"
			done
			;;
		*)
			prefix=$PWD
			;;
	esac
	mkdir -p "$(dirname "$HOME/$2")"
	if [ -L "$HOME/$2" ]; then
		echo "Symbolic link ~/$2 already exists"
	elif ln -s "$prefix/$1" "$HOME/$2"; then
		echo "~/$2" "->" "$prefix/$1"
	fi
}

set -e
cd "$(dirname $0)"
echo Home directory is "$HOME"
echo Settings directory is "$PWD"

makelink bashrc .bashrc
if command -v colordiff >/dev/null 2>&1; then
	makelink colordiffrc .colordiffrc
fi
if command -v dircolors >/dev/null 2>&1; then
	makelink dircolors .dircolors
fi
makelink inputrc .inputrc
makelink lesspipe.sh bin/lesspipe.sh
if ! [ $(PATH=$PATH:$PATH:$PATH which -a which 2>/dev/null | wc -l) -ge 3 ]
then
	makelink which bin/which
fi
if top --version 2>/dev/null | grep -q procps; then
	makelink toprc .toprc
fi
makelink yashrc .yashrc
makelink zshrc .zshrc

if command -v vim >/dev/null 2>&1; then
	makelink vimrc .vimrc
	makelink vimless bin/vimless
	makelink vim/filetype.vim .vim/filetype.vim
	makelink vim/ftdetect/v.vim .vim/ftdetect/v.vim
	makelink vim/indent/html.vim .vim/indent/html.vim
	makelink vim/syntax/sh.vim .vim/syntax/sh.vim
	makelink vim/macros/hgcommit.vim .vim/macros/hgcommit.vim
	makelink vim/macros/less.vim .vim/macros/less.vim
	vim/setup.sh
fi
