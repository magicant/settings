" magicant's filetype file

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect

autocmd! BufRead,BufNewFile install-sh call SetFileTypeShell("sh")

autocmd! BufRead,BufNewFile .yashrc*,yashrc,yash.yashrc,.yash_profile,*.yash call SetFileTypeYash()

function! SetFileTypeYash()
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
endfunction

augroup END
