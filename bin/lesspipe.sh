#!/bin/sh

if ! [ -r "$1" ]; then
    exit 1
fi
if ! [ -f "$1" ]; then
    if [ -d "$1" ]; then
        if ls --color / >/dev/null 2>&1; then
            color='--color'
        else
            color=
        fi
        CLICOLOR= CLICOLOR_FORCE= exec ls -al $color -- "$1"
    else
        # return non-zero status to force less to open the file as usual
        false
    fi
    exit
fi

case "$1" in
    /*) s1="$1" ;;
    *)  s1="./$1" ;;
esac
case "$1" in
    *.taz) r1="${1%.taz}.tar.Z" ;;
    *.tbz) r1="${1%.tbz}.tar.bz2" ;;
    *.tgz) r1="${1%.tgz}.tar.gz" ;;
    *.tlz) r1="${1%.tlz}.tar.lzma" ;;
    *.txz) r1="${1%.txz}.tar.xz" ;;
    *)     r1="$1" ;;
esac
case "$r1" in
    *.bz2)  u1="${r1%.bz2}"  decomp="bzcat" ;;
    *.gz)   u1="${r1%.gz}"   decomp="gunzip -c" ;;
    *.[zZ]) u1="${r1%.[zZ]}" decomp="zcat" ;;
    *.lzma) u1="${r1%.lzma}" decomp="lzma -dc" ;;
    *.xz)   u1="${r1%.xz}"   decomp="xz -dc" ;;
    *)      u1="$r1"         decomp="cat" ;;
esac
case "$u1" in
    *.tar )  $decomp -- "$1" | tar tvf - ; exit ;;
esac

case "${LC_ALL:-${LC_CTYPE:-$LANG}}" in
    *.UTF-8*     | *.UTF8*  | *.utf-8*     | *.utf8*  )  to=UTF-8 ;;
    *.EUC-JP*    | *.EUCJP* | *.euc-jp*    | *.eucjp* )  to=EUC-JP ;;
    *.Shift_JIS* | *.SJIS*  | *.shift_jis* | *.sjis*  )  to=SHIFT_JIS ;;
    *                                                 )  to= ;;
esac

case "$1" in

    # man page
    *.[1-9n] | *.[1-9n].gz | *.man | *.man.gz | *.[0-9][a-z].gz )
        case "$($decomp -- "$1" | file -)" in
            *troff* )  MAN_KEEP_FORMATTING=yes exec man -- "$s1" ; exit ;;
        esac
        ;;

    # archive
    *.zip | *.jar | *.nbm | *.apk)
                            exec zipinfo -- "$1"                ; exit ;;
    *.rpm )                 exec rpm -qivl --changelog -p "$s1" ; exit ;; 
    *.cpio | *.cpi )        exec cpio -itv <"$1"                ; exit ;; 
    *.a )                   exec ar -tv "$s1"                   ; exit ;; 

    # media
    *.gif | *.jpeg | *.jpg | *.pcd | *.png | *.tga | *.tiff | *.tif )
        exec identify -- "$1" ; exit ;;

    # portable object
    *.po | *.pot )
        exec msgcat --color=yes ${to:+--to-code="$to"} "$1" 2>/dev/null; exit ;;

esac

# text
case "$($decomp -- "$1" | nkf --guess 2>/dev/null)" in
    UTF-8*)       from=UTF-8 ;;
    EUC-JP*)      from=EUC-JP ;;
    Shift_JIS*)   from=SHIFT_JIS ;;
    ISO-2022-JP*) from=ISO-2022-JP ;;
    *)            from= ;;
esac
if [ "$from" ] && [ "$to" ] && [ "$from" != "$to" ]; then
    $decomp -- "$1" | exec iconv -cs -f "$from"
elif [ "$decomp" != "cat" ]; then
    exec $decomp -- "$1"
else
    # return non-zero status to force less to open the file as usual
    false
fi

# vim: ft=sh et sw=4 sts=4
