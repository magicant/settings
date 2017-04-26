#!/bin/sh

checkgetlatest () {
    # $1 = ScriptID (decimal integer)
    # $2 = Script name (any string, which may start with ":AutoInstall:")
    printf '%s: ' "$GLVSfile"
    if grep "^$1 " "$GLVS"; then
        :
    else
        echo "$1 1 $2" >>"$GLVS"
        echo "$1 1 $2 (added)"
    fi
}

set -Ceu
cd -- "$(dirname -- "$0")"

(
cd spell
find . -name '*.add' -exec echo vim: mkspell {} \; \
    -exec sh -c 'echo "verbose mkspell! $1" | vim -e -s -u NONE ; echo' \
        dummy {} \;
)
(
cd after/spell
echo vim: mkspell cjk.ascii
echo "verbose mkspell! cjk.ascii.spl cjk.ascii" | vim -e -s -u NONE
echo
)

GLVSfile="GetLatestVimScripts.dat"
GLVSdir="GetLatest"
GLVS="$GLVSdir/$GLVSfile"
if ! [ -e "$GLVS" ]; then
    mkdir -p "$GLVSdir"
    echo 'ScriptID SourceID Filename
--------------------------' >"$GLVS"
fi
checkgetlatest  294 ':AutoInstall: Align.vim'
checkgetlatest  302 ':AutoInstall: AnsiEsc.vim'
checkgetlatest  978 'ftplugin/svn.vim'
checkgetlatest 1066 ':AutoInstall: cecutil.vim'
checkgetlatest 1697 ':AutoInstall: surround.vim'
checkgetlatest 2063 'syntax/coq.vim'
checkgetlatest 2136 ':AutoInstall: autoload/repeat.vim'

# vim: ft=sh et sw=4 sts=4
