#!/bin/sh

set -Ceu
cd -- "$(dirname "$0")"

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

# vim: ft=sh et sw=4 sts=4
