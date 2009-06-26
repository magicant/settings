#!/bin/sh

# To use this file, put the following line in the [ui] section of ~/.hgrc
# editor = <path to this file>

case "${VISUAL:-${EDITOR:-}}" in
	"")
		EDITOR=vi
		;;
	gvim|vim)
		hgcommitvim=~/.vim/macros/hgcommit.vim
		if [ -r $hgcommitvim ]; then
			EDITOR="$EDITOR -f -S $hgcommitvim"
		fi
		;;
esac
exec $EDITOR "$@"
