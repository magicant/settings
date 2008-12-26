" .vimrc of magicant

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp932,euc-jp,iso-2022-jp,ucs-2le,ucs-2
set nobackup hidden confirm

highlight Normal guibg=Black guifg=White
set guioptions-=T guicursor+=a:blinkwait500-blinkon500-blinkoff500

set background=dark
filetype plugin indent on
syntax on

set nohlsearch incsearch noshowmatch ignorecase smartcase
set nolist listchars=eol:$,tab:>.

set autoindent smartindent cindent
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

set nocscopetag cscopequickfix=s-,c-,d-,i-,t-,e-

set showcmd cmdheight=1 laststatus=2
set statusline=%n\ %f\ %h%m%r%w%y%=%-14.(%l/%L,%c%V%)\ %P
set wildmenu
set title

set winheight=3

" XXX: linewise visual では本来の動作に戻したいなぁ……
noremap j gj
noremap gj j
noremap k gk
noremap gk k
nmap <Down> j
nmap <Up> k
" XXX: 'wrap' が有効かどうかによって g0 にマップするか決めたいなぁ……
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
noremap Y y$
map n /<Return>
map N ?<Return>

" for :TOhtml
let html_use_css=1
" for [sh] filetype
let is_kornshell=1
" for [c] filetype
let c_no_curly_error=1
let c_gnu=1
" for [h] filetype
let c_syntax_for_h=1
" for :compiler tex
let tex_flavor="platex"

if filereadable($HOME."/.vimrc_local")
	source ~/.vimrc_local
endif
