#!/bin/sh

makelink () {
	if
		if [ -L ~/"$2" ]; then
			printf "~/$2 already exists as a symbolic link. "
			false
		elif [ -e ~/"$2" ]; then
			printf "~/$2 already exists. overwrite? [y/n]: "
			read input
			case "$input" in
				(Y*|y*) true;;
				(*)     false;;
			esac
		fi
	then
		prefix=""
		t="$(dirname "$2")"
		until [ x"$t" = x"." ]; do
			prefix="$prefix../"
			t="$(dirname "$t")"
		done
		echo ln -fs "$prefix${PWD#${HOME%/}/}/$1" ~/"$2"
		ln -fs "$prefix${PWD#${HOME%/}/}/$1" ~/"$2"
	else
		printf "Skipping $2\n"
	fi
}

cd "$(dirname $0)"
if [ x"$PWD" = x"${PWD#$HOME}" ]; then
	printf "We're not in the home directory! Aborting.\n"
	exit 2
fi

makelink bashrc .bashrc
makelink colordiffrc .colordiffrc
makelink dircolors .dircolors
makelink inputrc .inputrc
makelink lesspipe.sh bin/lesspipe.sh
top --version 2>/dev/null | grep -q procps && makelink toprc .toprc
makelink vimrc .vimrc
makelink yashrc .yashrc
