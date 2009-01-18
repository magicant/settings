" magicant's filetype file

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect

au! BufRead,BufNewFile install-sh call SetFileTypeShell("sh")

au! BufRead,BufNewFile .yashrc*,yashrc,yash.yashrc,.yash_profile,*.yash call SetFileTypeYash()

func! SetFileTypeYash()
	if exists("b:is_sh")
		unlet b:is_sh
	endif
	if exists("b:is_kornshell")
		unlet b:is_kornshell
	endif
	if exists("b:is_bash")
		unlet b:is_bash
	endif
	let b:is_yash = 1
	call SetFileTypeShell("sh")
endfunc

augroup END
