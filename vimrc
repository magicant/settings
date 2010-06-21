" .vimrc of magicant

if has("multi_byte")
	if !has("gui_running")
		let &termencoding = &encoding
	endif
	set encoding=utf-8
	set fileencodings=ucs-bom,iso-2022-jp,utf-8,sjis,cp932,euc-jp,cp20932
	if has("autocmd")
		augroup fileencoding
			autocmd!
			autocmd BufReadPost * call s:check_fileencoding()
			" Use default encoding for ASCII-only text
			function! s:check_fileencoding()
				if search("[^\1-\177]", 'cnw') == 0
					silent! setlocal fileencoding=
				endif
			endfunction
		augroup END
	endif
	noremap <F8> :call <SID>switchambiwidth()<CR>
	function! s:switchambiwidth()
		if &ambiwidth == "single"
			set ambiwidth=double
		elseif &ambiwidth == "double"
			set ambiwidth=single
		endif
		redraw
		set ambiwidth?
	endfunction
endif

set iminsert=0 imsearch=-1
set modeline modelines=5
set hidden confirm
set nobackup nowritebackup swapsync=
set suffixes+=.out,.a,.cmi,.cmo,.cmx,.cma,.cmxa
if exists("&fsync")
	set nofsync
endif

highlight Normal guibg=Black guifg=LightGray
set guioptions+=f guioptions-=tT
set guicursor+=a:blinkwait500-blinkon500-blinkoff500
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
	noremap <F7> :set spell! spell?<CR>
endif
if &t_ts == '' && &t_fs == ''
	if &term =~? '^\(xterm\|gnome\|putty\)\>'
		let [&t_ts, &t_fs] = ["\e]0;", "\7"]
	endif
endif

set ignorecase smartcase
if has("extra_search")
	set nohlsearch incsearch
endif
set nolist listchars=eol:$,tab:>.
set display=lastline
set noshowmatch
set backspace=indent,eol,start
set virtualedit=block
set nojoinspaces
set autoindent
set tabstop=4 shiftwidth=4
set formatoptions=tcroqnlB

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
	command! -nargs=* -complete=file -complete=shellcmd Start
		\ silent ! start <args>
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
inoremap <C-U> <C-G>u<C-U>
noremap Y y$
map n /<Return>
map N ?<Return>
noremap <C-W>Q :quitall<CR>
noremap \n :cnext<CR>
noremap \p :cprevious<CR>

if has("autocmd")
	augroup autojump
		autocmd!
		" When editing a file, always jump to the last cursor position
		autocmd BufReadPost * call s:autojump()
		function! s:autojump()
			if line("'\"") > 0 && line ("'\"") <= line("$")
				execute "normal! g'\""
			endif
		endfunction
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

	" Coding style selector
	"   original script written by tyru: http://vim-users.jp/2010/05/hack149/
	"   modified by magicant
	let s:styles = {}
	let s:styles['my']     = 'set noet ts=4 sw=4 sts&'
	let s:styles['short']  = 'set   et ts=2 sw=2 sts&'
	let s:styles['GNU']    = 'set   et ts=8 sw=2 sts=2'
	let s:styles['BSD']    = 'set noet ts=8 sw=4 sts&'
	let s:styles['Linux']  = 'set noet ts=8 sw=8 sts&'
	command! -bar -nargs=1 -complete=custom,s:style_complete
		\ Style execute get(s:styles, <f-args>, '')
	function! s:style_complete(...)
		return join(keys(s:styles), "\n")
	endfunction
endif

if filereadable($HOME."/.vimrc_local")
	source ~/.vimrc_local
elseif filereadable($HOME."/_vimrc_local")
	source ~/_vimrc_local
endif
