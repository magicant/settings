" re-set the formatoptions option, which have been set during filetype
" detection

autocmd BufNewFile,BufRead,StdinReadPost *
	\ setlocal formatoptions+=tcronlB formatoptions-=M
