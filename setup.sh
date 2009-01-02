#!/bin/sh

makelink () {
	prefix=""
	t="$(dirname "$2")"
	until [ x"$t" = x"." ]; do
		prefix="$prefix../"
		t="$(dirname "$t")"
	done
	mkdir -p "$(dirname ~/"$2")" &&
	ln -s "$prefix${PWD#${HOME%/}/}/$1" ~/"$2" &&
	echo ~/"$2" "->" "$prefix${PWD#${HOME%/}/}/$1"
}

cd "$(dirname $0)"
if [ x"$PWD" = x"${PWD#$HOME}" ]; then
	printf "We're not in the home directory! Aborting.\n"
	exit 1
fi

makelink bashrc .bashrc
command -v colordiff >/dev/null 2>&1 && makelink colordiffrc .colordiffrc
command -v dircolors >/dev/null 2>&1 && makelink dircolors .dircolors
makelink inputrc .inputrc
makelink lesspipe.sh bin/lesspipe.sh
top --version 2>/dev/null | grep -q procps && makelink toprc .toprc
makelink yashrc .yashrc

if command -v vim >/dev/null 2>&1; then
	makelink vimrc .vimrc
	makelink vimless bin/vimless
	makelink vim/filetype.vim .vim/filetype.vim
	./vim/setup.sh
fi

exit 0
