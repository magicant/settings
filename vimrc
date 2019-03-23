" .vimrc of magicant

" encoding options
if has("multi_byte")
    if !has("gui_running")
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    set fileencodings=ucs-bom,iso-2022-jp,utf-8,sjis,cp932,euc-jp,cp20932
    scriptencoding utf-8
endif

" moving and searching options
set ignorecase smartcase
if has("extra_search")
    set nohlsearch incsearch
endif

" tag options
if has("cscope")
    set cscopetag cscopetagorder=1 cscopequickfix=s-,c-,d-,i-,t-,e-
endif

" display options
if has("linebreak")
    set linebreak showbreak=>>
    noremap <S-F9> :set linebreak! linebreak?<CR>
    if exists("&breakindent")
        set breakindent
    endif
endif
set display=lastline
set cmdheight=1
set nolist listchars=eol:$,tab:>.
set nonumber

" syntax, highlighting and spelling options
colorscheme magicant
if has("autocmd")
    filetype plugin indent on
endif
if has("syntax")
    syntax enable
    set spell spelllang+=cjk
    noremap <F7> :set spell! spell?<CR>
endif

" window options
set laststatus=2
if has("statusline")
    set statusline=%n\ %f\ %h%m%r%w%y%=%-14.(%l/%L,%v%)\ %P
endif
set noequalalways
if has("windows")
    set winheight=3
    set splitbelow
endif
if has("vertsplit")
    set splitright
endif
set hidden

" terminal options
if &t_ts == '' && &t_fs == ''
    if &term =~? '^\(xterm\|gnome\|putty\)\>'
        let [&t_ts, &t_fs] = ["\e]0;", "\7"]
    endif
endif
if exists('+t_SI') && exists('+t_EI') && &t_SI == '' && &t_EI == ''
    if &term =~? '^gnome\>' ||
                \ $TERM_PROGRAM =~? '\<\(mintty\|Apple_Terminal\|iTerm\)\>'
        let [&t_SI, &t_EI] = ["\<Esc>[5 q", "\<Esc>[0 q"]
        if exists('+t_SR')
            let &t_SR = "\<Esc>[3 q"
        endif
    endif
endif
if has("title")
    set title
endif

" GUI options
set guicursor+=a:blinkwait500-blinkon500-blinkoff500
set guioptions-=tT
if has("gui_win32")
    set winaltkeys=yes
endif

" message options
if has("cmdline_info")
    set showcmd
endif
set confirm

" editing options
set backspace=indent,eol,start
set virtualedit=block
set formatoptions+=tcronlB formatoptions-=mM
set noshowmatch
set nojoinspaces
set tabstop& shiftwidth& softtabstop& noexpandtab shiftround
set autoindent

" mapping options
set notimeout ttimeout timeoutlen=1000 ttimeoutlen=100

" file reading/writing options
set modeline& modelines&
set nobackup nowritebackup
set noautowrite noautowriteall nowriteany
if exists("&fsync")
    set nofsync
endif

" swap file options
if (has("win32") || has("win64")) && ($TEMP != "")
    let &directory = ".," . $TEMP
endif
set swapsync=

" command line options
set history=500
set wildmode=longest:full,full
if has("wildmenu")
    set wildmenu
endif
set suffixes+=.out,.a,.cmi,.cmo,.cmx,.cma,.cmxa,.mo

" external command options
if &shell !~? '\<yash$'
    silent let @_ = system("yash --version")
    if v:shell_error == 0
        set shell=yash
    endif
endif
if &shell =~? 'c\@<!sh$'
    set shellredir=>%s\ 2>&1
endif

" quickfix options
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
    set errorformat+=%D%*\\a[%*\\d]:\ ディレクトリ\ %[`']%f'\ に入ります
    set errorformat+=%X%*\\a[%*\\d]:\ ディレクトリ\ %[`']%f'\ から出ます
endif

" i18n options
set iminsert=0 imsearch=-1
if has("multi_byte")
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

" other options
set viminfo& viminfo+=/50,:300,@50
set pastetoggle=<F5>


" mappings and commands
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
noremap <C-K><C-A> :wall<CR>
noremap <C-K>a :wall<CR>
noremap <C-K><C-U> :update<CR>
noremap <C-K>u :update<CR>
noremap <C-K><C-W> :write<CR>
noremap <C-K>w :write<CR>
noremap <C-K><C-X> :exit<CR>
noremap <C-K>x :exit<CR>
noremap <C-K>X :xall<CR>
noremap <C-W>Q :quitall<CR>
noremap <F5> :set paste! paste?<CR>
noremap <F6> :set list! list?<CR>
noremap <F9> :set wrap! wrap?<CR>
noremap [A :first<CR>
noremap ]A :last<CR>
noremap [B :bfirst<CR>
noremap ]B :blast<CR>
noremap [Q :cfirst<CR>
noremap ]Q :clast<CR>
noremap [L :lfirst<CR>
noremap ]L :llast<CR>
noremap <C-Tab> <C-PageDown>
noremap <C-S-Tab> <C-PageUp>
if has("win32") || has("win64")
    command! -nargs=* -complete=file -complete=shellcmd Start
        \ silent ! start <args>
endif
if has("eval")
    function! s:execcommandrange(command) range abort
        execute (a:lastline - a:firstline + 1) . a:command
    endfunction
    noremap [a :call <SID>execcommandrange("previous")<CR>
    noremap ]a :call <SID>execcommandrange("next")<CR>
    noremap [b :call <SID>execcommandrange("bprevious")<CR>
    noremap ]b :call <SID>execcommandrange("bnext")<CR>
    noremap [q :call <SID>execcommandrange("cprevious")<CR>
    noremap ]q :call <SID>execcommandrange("cnext")<CR>
    noremap [l :call <SID>execcommandrange("lprevious")<CR>
    noremap ]l :call <SID>execcommandrange("lnext")<CR>
endif
if has("gui_macvim")
    map <D-1> 1gt
    map <D-2> 2gt
    map <D-3> 3gt
    map <D-4> 4gt
    map <D-5> 5gt
    map <D-6> 6gt
    map <D-7> 7gt
    map <D-8> 8gt
    map <D-9> 9gt
endif


" auto commands
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


" other settings
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
    let s:styles['tab2']   = 'set noet ts=2 sw=2 sts&'
    let s:styles['tab4']   = 'set noet ts=4 sw=4 sts&'
    let s:styles['tab8']   = 'set noet ts=8 sw=8 sts&'
    let s:styles['mix2']   = 'set noet ts=8 sw=2 sts=2'
    let s:styles['mix4']   = 'set noet ts=8 sw=4 sts=4'
    let s:styles['space2'] = 'set   et ts=8 sw=2 sts=2'
    let s:styles['space4'] = 'set   et ts=8 sw=4 sts=4'
    let s:styles['space8'] = 'set   et ts=8 sw=8 sts&'
    command! -bar -nargs=? -complete=custom,s:style_complete
        \ Style call s:style_main(<f-args>)
    function! s:style_main(...)
        if a:0 == 0
            set et? ts? sw? sts?
        else
            execute get(s:styles, a:1, 'echoerr "Unknown style: " . a:1')
        endif
    endfunction
    function! s:style_complete(...)
        return join(keys(s:styles), "\n")
    endfunction
endif


" local settings
if filereadable($HOME."/.vimrc_local")
    source ~/.vimrc_local
elseif filereadable($HOME."/_vimrc_local")
    source ~/_vimrc_local
endif

" vim: et sw=4 sts=4
