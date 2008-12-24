#!/bin/sh -

lesspipe() {
  unset DECOMPRESSOR
  case "$1" in
	*.[1-9n]|*.man|*.[1-9n].bz2|*.man.bz2|*.[1-9].gz|*.[1-9]x.gz|*.[1-9].man.gz)
	case "$1" in
	  *.gz)	DECOMPRESSOR="gunzip -c" ;;
	  *.bz2)	DECOMPRESSOR="bunzip2 -c" ;;
	  *)	DECOMPRESSOR="cat" ;;
	esac
	if $DECOMPRESSOR -- "$1" | file - | grep -q troff; then
	  if echo "$1" | grep -q ^/; then	#absolute path
		man -- "$1" | cat -s
	  else
		man -- "./$1" | cat -s
	  fi
	else
	  $DECOMPRESSOR -- "$1"
	fi ;;
	*.tar) tar tvf "$1" | sort -k6 ;;
	*.tgz|*.tar.gz|*.tar.[zZ]) tar tzvf "$1" | sort -k6 ;;
	*.tar.bz2|*.tbz2) tar tjvf - | sort -k6 ;;
	*.[zZ]|*.gz) gzip -dc -- "$1" ;;
	*.bz2) bzip2 -dc -- "$1" ;;
	*.zip) zipinfo -- "$1" ;;
	*.rpm) rpm -qpivl --changelog -- "$1" ;;
	*.cpi|*.cpio) cpio -itv < "$1" ;;
	*.gif|*.jpeg|*.jpg|*.pcd|*.png|*.tga|*.tiff|*.tif) identify -- "$1" ;;
	*)
	case `nkf --guess -- "$1"` in
	  UTF-8|ASCII) ;;
	  *)  nkf -wx --no-best-fit-chars -- "$1" ;;
	esac
  esac
}

if [ -d "$1" ] ; then
  ls -alF --color -- "$1"
else
  lesspipe "$1" 2> /dev/null
fi
