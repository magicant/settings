#!/bin/sh

applypatch () {
	if [ -e ~/.vim/"$1" ]; then
		echo "~/.vim/$1 already exists"
	else
		mkdir -p "`dirname ~/.vim/"$1"`" &&
		cp "$VIMRUNTIME/$1" ~/.vim/"$1" &&
		(cd "`dirname ~/.vim/"$1"`" && patch) <"$1.patch" &&
		echo "~/.vim/$1 successfully patched" 
	fi
}
checkgetlatest () {
	# $1 = ScriptID (decimal integer)
	# $2 = Script name (any string, which may start with ":AutoInstall:")
	if ! grep -q "^$1 " ~/.vim/GetLatest/GetLatestVimScripts.dat; then
		echo GetLatestVimScripts.dat: "$1 1 $2"
		echo "$1 1 $2" >>~/.vim/GetLatest/GetLatestVimScripts.dat
	fi
}

cd "`dirname $0`"
if echo "//$PWD" | grep -Fqv "//$HOME"; then
	printf "We're not in the home directory! Aborting.\n"
	exit 1
fi

VIMRUNTIME=`echo '!echo $VIMRUNTIME' | vim -e -s`
if [ -z "$VIMRUNTIME" ]; then
	printf "cannot find \$VIMRUNTIME."
	exit 1
fi

applypatch syntax/html.vim

if [ ! -e ~/.vim/GetLatest/GetLatestVimScripts.dat ]; then
	mkdir -p ~/.vim/GetLatest
	echo 'ScriptID SourceID Filename
--------------------------' >~/.vim/GetLatest/GetLatestVimScripts.dat
fi
checkgetlatest  294 ':AutoInstall: Align.vim'
checkgetlatest  978 'ftplugin/svn.vim'
checkgetlatest 1066 ':AutoInstall: cecutil.vim'
checkgetlatest 1632 'indent/sh.vim'

exit 0
