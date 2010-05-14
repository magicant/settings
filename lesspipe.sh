#!/bin/sh

unset color
case "${LESS-}" in
  *R*) color=true ;;
esac

if ! [ -f "$1" ]; then
  if [ -d "$1" ]; then
	exec ls -al ${color+--color} -- "$1"
  fi
  exit
fi

case "$1" in
  /*) s1="$1" ;;
  *)  s1="./$1" ;;
esac
case "$1" in
  *.gz)   decomp="gunzip -c" ;;
  *.bz2)  decomp="bzcat" ;;
  *.[zZ]) decomp="zcat" ;;
  *)      decomp="cat" ;;
esac

opentext() {
  if [ "$decomp" != "cat" ]; then
	exec $decomp -- "$1"
  fi
  exit
}

case "$1" in

  # man page
  *.[1-9n]     | *.man     | \
  *.[1-9n].gz  | *.man.gz  | \
  *.[1-9n].bz2 | *.man.bz2 | \
  *.[0-9][a-z].gz )
	case "$($decomp -- "$1" | file -)" in
	  *troff*)
		exec man -- "$s1" ; exit
		;;
	  *text*)
		opentext
		;;
	esac
	;;

  # archive
  *.tar )                          exec tar -tv  -f "$1" | sort -k 6 ; exit ;;
  *.tar.gz | *.tgz | *.tar.[zZ] )  exec tar -tvz -f "$1" | sort -k 6 ; exit ;;
  *.tar.bz2 | *.tbz2 | *.tgz )     exec tar -tvj -f "$1" | sort -k 6 ; exit ;;
  *.zip | *.jar | *.nbm)           exec zipinfo -- "$1" ; exit ;;
  *.rpm)            exec rpm -qpivl --changelog "$s1" ; exit ;;
  *.cpio | *.cpi )  exec cpio -itv <"$1" ; exit ;;
  *.a )             exec ar -tv "$s1" ; exit ;;
  *.so )            exec readelf -edsA -- "$1" ; exit ;;

  # media
  *.gif | *.jpeg | *.jpg | *.pcd | *.png | *.tga | *.tiff | *.tif )
	exec identify -- "$1" ; exit ;;

esac


# text
case "$($decomp -- "$1" | nkf --guess 2>/dev/null)" in
  UTF-8*)       from=UTF-8 ;;
  EUC-JP*)      from=EUC-JP ;;
  Shift_JIS*)   from=SHIFT_JIS ;;
  ISO-2022-JP*) from=ISO-2022-JP ;;
  *)  # no conversion
	opentext "$1" ;;
esac
case "${LC_ALL:-${LC_CTYPE:-$LANG}}" in
  *.UTF-8*     | *.UTF8*  | *.utf-8*     | *.utf8*  )  to=UTF-8 ;;
  *.EUC-JP*    | *.EUCJP* | *.euc-jp*    | *.eucjp* )  to=EUC-JP ;;
  *.Shift_JIS* | *.SJIS*  | *.shift_jis* | *.sjis*  )  to=SHIFT_JIS ;;
  *)  # no conversion
	opentext "$1" ;;
esac
if [ "$from" = "$to" ]; then
  # no conversion
  opentext "$1"
else
  $decomp -- "$1" | exec iconv -cs -f "$from"
fi

# vim: ts=4 sw=2 sts=2
