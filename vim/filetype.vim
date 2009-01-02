" magicant's filetype file

if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufRead,BufNewFile .yashrc*,yashrc,yash.yashrc,.yash_profile,*.yash setfiletype sh
augroup END
