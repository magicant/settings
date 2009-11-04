" .vimrc of magicant

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,utf-16,utf-16le
set iminsert=0 imsearch=-1
set modeline modelines=5
set nobackup nowritebackup hidden confirm
set suffixes+=.out,.a,.cmi,.cmo,.cmx,.cma,.cmxa
if has("multi_byte")
	noremap <F8> :call <SID>switchambiwidth()<CR>
	function! s:switchambiwidth()
		if &ambiwidth == "single"
			set ambiwidth=double
		elseif &ambiwidth == "double"
			set ambiwidth=single
		endif
		redraw
		echo "ambiwidth=" . &ambiwidth
	endfunction
endif

highlight Normal guibg=Black guifg=LightGray
set guioptions+=f guioptions-=T guicursor+=a:blinkwait500-blinkon500-blinkoff500
set timeout timeoutlen=1000 ttimeoutlen=100
if has("gui_win32")
	set winaltkeys=yes
endif

set background=dark
if has("autocmd")
	filetype plugin indent on
endif
if has("syntax")
	syntax enable
endif

set ignorecase smartcase
if has("extra_search")
	set nohlsearch incsearch
endif
set nolist listchars=eol:$,tab:>.
set display=lastline

set noshowmatch
set backspace=indent,eol,start
set autoindent
set tabstop=4 shiftwidth=4
set formatoptions+=tcroqlB formatoptions-=M

if &shell =~ 'c\@<!sh$'
	set shellredir=>%s\ 2>&1
endif
if has("quickfix")
	if &shell =~ 'c\@<!sh$'
		set shellpipe=2>&1\|tee
	endif
	set errorformat-=%-G%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
	set errorformat-=%-G%f:%l:\ for\ each\ function\ it\ appears\ in.)
	set errorformat-=%f:%l:%c:%m
	set errorformat-=%f:%l:%m
	set errorformat+=%-G%f:%l:\ error:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once
	set errorformat+=%-G%f:%l:\ error:\ for\ each\ function\ it\ appears\ in.)
	set errorformat+=%f:%l:%c:%m
	set errorformat+=%f:%l:%m
	set errorformat+=%D%*\\a[%*\\d]:\ ディレクトリ\ `%f'\ に入ります
	set errorformat+=%X%*\\a[%*\\d]:\ ディレクトリ\ `%f'\ から出ます
endif
if has("win32") || has("win64")
	command! -nargs=* -complete=file -complete=shellcmd Start silent ! start <args>
endif

if has("cscope")
	set cscopetag cscopetagorder=1 cscopequickfix=s-,c-,d-,i-,t-,e-
endif

set cmdheight=1 laststatus=2 history=100
if has("cmdline_info")
	set showcmd
endif
if has("statusline")
	set statusline=%n\ %f\ %h%m%r%w%y%=%-14.(%l/%L,%v%)\ %P
endif
if has("wildmenu")
	set wildmenu
endif
if has("windows")
	set winheight=3
endif
if has("title")
	set title
endif

imap <C-@> <Esc>
cmap <C-@> <C-C>
vmap <C-@> <Esc>
map  <C-Space> <C-@>
map! <C-Space> <C-@>
inoremap <C-B> <C-G>u
noremap Y y$
map n /<Return>
map N ?<Return>

if has("autocmd")
	augroup autojump
		autocmd!
		function! s:autojump()
			if line("'\"") > 0 && line ("'\"") <= line("$") |
				execute "normal! g'\"" |
			endif
		endfunction
		" When editing a file, always jump to the last cursor position
		autocmd BufReadPost * call s:autojump()
	augroup END
endif

if has("eval")
	" for :TOhtml
	let g:html_use_css=1
	" for [c] filetype
	let g:c_no_curly_error=1
	let g:c_gnu=1
	" for [h] filetype
	let g:c_syntax_for_h=1
	" for [sh] filetype
	let g:sh_indent_case_labels=1
	" for [v] filetype
	let g:v_default_filetype="coq"
	" for :compiler tex
	let g:tex_flavor="platex"
endif

if filereadable($HOME."/.vimrc_local")
	source ~/.vimrc_local
elseif filereadable($HOME."/_vimrc_local")
	source ~/_vimrc_local
endif
