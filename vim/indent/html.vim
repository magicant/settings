" Description:  indent definition for html files
" Author:       Watanabe, Yuki <magicant.starmen AT nifty.com>

if exists("b:did_indent")
    finish
endif

let b:did_indent = 1

setlocal autoindent nosmartindent nocindent indentexpr&

" vim: et sw=4 sts=4
