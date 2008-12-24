" magicant's filetype file

if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufRead,BufNewFile .yashrc         setfiletype sh
	au! BufRead,BufNewFile .yash_profile   setfiletype sh
augroup END
