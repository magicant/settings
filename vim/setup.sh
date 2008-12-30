#!/bin/sh

applypatch () {
	if [ -e ~/.vim/"$1" ]; then
		echo "~/.vim/$1 already exists"
	else
		mkdir -p "$(dirname ~/.vim/"$1")" &&
		cp "$VIMRUNTIME/$1" ~/.vim/"$1" &&
		(cd "$(dirname ~/.vim/"$1")" && patch) <"$1.patch" &&
		echo "~/.vim/$1 successfully patched" 
	fi
}

cd "$(dirname $0)"
if [ x"$PWD" = x"${PWD#$HOME}" ]; then
	printf "We're not in the home directory! Aborting.\n"
	exit 1
fi

VIMRUNTIME=$(echo '!echo $VIMRUNTIME' | vim -e -s)
if [ -z "$VIMRUNTIME" ]; then
	printf "cannot find \$VIMRUNTIME."
	exit 1
fi

applypatch indent/html.vim
applypatch macros/less.vim
applypatch syntax/html.vim

exit 0
