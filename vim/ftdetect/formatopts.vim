" re-set the formatoptions option, which have been set during filetype
" detection

autocmd BufNewFile,BufRead,StdinReadPost *
    \ setlocal formatoptions+=lB formatoptions-=mM

" vim: et sw=4 sts=4
