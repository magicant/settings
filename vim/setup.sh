#!/bin/sh

applypatch () {
	#TODO
}

cd "$(dirname $0)"
if [ x"$PWD" = x"${PWD#$HOME}" ]; then
	printf "We're not in the home directory! Aborting.\n"
	exit 2
fi

if ! command -v vim >/dev/null 2>&1; then
	echo "vim not available. patches not applied."
	exit
fi

VIMRUNTIME=$(echo '!echo $VIMRUNTIME' | vim -e -s)

applypatch indent/html.vim
applypatch macros/less.vim
applypatch syntax/html.vim
