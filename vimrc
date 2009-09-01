" .vimrc of magicant

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,utf-16,utf-16le
set iminsert=0 imsearch=-1
set modeline modelines=5
set nobackup hidden confirm
set suffixes+=.out,.a,.cmi,.cmo,.cmx,.cma,.cmxa

highlight Normal guibg=Black guifg=LightGray
set guioptions+=f guioptions-=T guicursor+=a:blinkwait500-blinkon500-blinkoff500
set timeout timeoutlen=1000 ttimeoutlen=100

set background=dark
if has("autocmd")
	filetype plugin indent on
endif
if has("syntax")
	syntax enable
endif

set nohlsearch incsearch noshowmatch ignorecase smartcase
set nolist listchars=eol:$,tab:>.

set backspace=indent,eol,start
set autoindent
set tabstop=4 shiftwidth=4
set formatoptions+=tcroqlB formatoptions-=M

if &shell =~ "/yash$"
	set shellpipe=2>&1\|tee shellredir=>%s\ 2>&1
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

if has("cscope")
	set cscopetag cscopetagorder=1 cscopequickfix=s-,c-,d-,i-,t-,e-
endif

set showcmd cmdheight=1 laststatus=2 history=50
set statusline=%n\ %f\ %h%m%r%w%y%=%-14.(%l/%L,%v%)\ %P
set wildmenu
set title

set winheight=3

" XXX: linewise visual では本来の動作に戻したいなぁ……
noremap j gj
noremap gj j
noremap k gk
noremap gk k
map <Down> j
map <Up> k
noremap 0 g0
noremap g0 0
noremap $ g$
noremap g$ $
noremap ^ g^
noremap g^ ^
map <Home> 0
map <End> $
imap <Down> <C-O><Down>
imap <Up> <C-O><Up>
imap <C-@> <Esc>
cmap <C-@> <C-C>
vmap <C-@> <Esc>
map  <C-Space> <C-@>
map! <C-Space> <C-@>
noremap Y y$
map n /<Return>
map N ?<Return>

if has("autocmd")
	augroup autojump
		autocmd!
		" When editing a file, always jump to the last cursor position
		autocmd BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   execute "normal! g'\"" |
		\ endif
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
	" for :compiler tex
	let g:tex_flavor="platex"
endif

if filereadable($HOME."/.vimrc_local")
	source ~/.vimrc_local
elseif filereadable($HOME."/_vimrc_local")
	source ~/_vimrc_local
endif
