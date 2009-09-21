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
	echo "~/$2" "->" "$prefix${PWD#${HOME%/}/}/$1"
}

cd "$(dirname $0)"
echo Home directory is "$HOME"
if [ x"$PWD" = x"${PWD#$HOME}" ]; then
	printf "We're not in the home directory! Aborting.\n"
	exit 1
fi

makelink bashrc .bashrc
command -v colordiff >/dev/null 2>&1 && makelink colordiffrc .colordiffrc
command -v dircolors >/dev/null 2>&1 && makelink dircolors .dircolors
makelink inputrc .inputrc
makelink lesspipe.sh bin/lesspipe.sh
which --version 2>/dev/null | grep -q GNU || makelink which bin/which
top --version 2>/dev/null | grep -q procps && makelink toprc .toprc
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
	./vim/setup.sh
fi

exit 0
