" Vim script to make Vim work like "less"
" Based on Bram's script.
" Author:  Watanabe Yuki <magicant.starmen AT nifty.com>
" License: Vim License

if &compatible
    set nocompatible
endif
syntax enable
set shortmess+=filnrxt
set hlsearch nowrapscan
nohlsearch
set viminfo= noswapfile

augroup less

    autocmd!

    " When reading from stdin don't consider the file modified.
    autocmd VimEnter * set nomodified

    " Activate less-like behavior when a buffer is loaded
    autocmd VimEnter,BufReadPost * call Vimless()

augroup END

" vim: et sw=4 sts=4
