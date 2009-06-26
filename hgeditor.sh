#!/bin/sh

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
