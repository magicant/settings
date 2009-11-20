#!/bin/sh

applypatch () {
	if [ -e "$HOME/.vim/$1" ]; then
		echo "~/.vim/$1 already exists"
	else
		mkdir -p "`dirname "$HOME/.vim/$1"`"
		cp "$VIMRUNTIME/$1" "$HOME/.vim/$1"
		(cd "`dirname "$HOME/.vim/$1"`" && patch) <"$1.patch" &&
		echo "~/.vim/$1 successfully patched" 
	fi
}
checkgetlatest () {
	# $1 = ScriptID (decimal integer)
	# $2 = Script name (any string, which may start with ":AutoInstall:")
	printf 'GetLatestVimScripts.dat: '
	if grep "^$1 " "$HOME/.vim/GetLatest/GetLatestVimScripts.dat"; then
		:
	else
		echo "$1 1 $2" >>"$HOME/.vim/GetLatest/GetLatestVimScripts.dat"
		echo "$1 1 $2 (added)"
	fi
}

set -e
cd "`dirname $0`"

VIMRUNTIME=`echo '!echo $VIMRUNTIME' | vim -e -s`
if [ -z "$VIMRUNTIME" ]; then
	printf "cannot find \$VIMRUNTIME."
	exit 1
fi

applypatch syntax/html.vim

if [ ! -e "$HOME/.vim/GetLatest/GetLatestVimScripts.dat" ]; then
	mkdir -p "$HOME/.vim/GetLatest"
	echo 'ScriptID SourceID Filename
--------------------------' >"$HOME/.vim/GetLatest/GetLatestVimScripts.dat"
fi
checkgetlatest  294 ':AutoInstall: Align.vim'
checkgetlatest  978 'ftplugin/svn.vim'
checkgetlatest 1066 ':AutoInstall: cecutil.vim'
checkgetlatest 1632 'indent/sh.vim'
checkgetlatest 2063 'syntax/coq.vim'
