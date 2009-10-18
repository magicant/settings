" Vim script to work like "less"
" Based on Bram's script.
" Author:  Watanabe Yuki <magicant.starmen@nifty.com>

if exists("loaded_less")
  finish
endif
let loaded_less = 1

set nocompatible
syntax on
let s:scrolloff = &scrolloff
set scrolloff=999
let s:shortmess = &shortmess
set shortmess+=filnrxt
set hlsearch nowrapscan
nohlsearch
" Don't remember file names and positions
set viminfo= noswapfile
" Inhibit screen updates while searching
let s:lazyredraw = &lazyredraw
set lazyredraw
let s:timeoutlen = &timeoutlen
set timeoutlen=100
set startofline

augroup less

" When reading from stdin don't consider the file modified.
autocmd VimEnter * set nomodified

" Always start at the beginning of the file.
autocmd VimEnter,BufEnter * goto

" open folds
if has("folding")
  autocmd VimEnter,BufEnter * set foldlevel=999
endif

augroup END

" Can't modify the text
set nomodifiable

" Give help
noremap h :call <SID>Help()<CR>
map H h
function! s:Help()
  echo "<Space>   One page forward          b         One page backward"
  echo "d         Half a page forward       u         Half a page backward"
  echo "<Enter>   One line forward          k         One line backward"
  echo "G         End of file               g         Start of file"
  echo "N%        percentage in file"
  echo "\n"
  echo "/pattern  Search for pattern        ?pattern  Search backward for pattern"
  echo "n         next pattern match        N         Previous pattern match"
  echo "\n"
  echo ":n        Next file                 :prev     Previous file"
  echo "q         Quit                      v         Edit file"
endfunction

" Redraw
noremap <script> <SID><C-L> g0:redraw!<CR><C-G>
noremap <script> <SID><C-G> :redraw<CR><C-G>
noremap <script> <C-L> <SID><C-L>
map L <C-L>
map r <C-L>
map R <C-L>
map <C-R> <C-L>

" Disable default mapping
noremap l <Esc>
noremap t <Esc>
noremap <BS> <Esc>

" Scroll one page forward
noremap <script> <C-F> <C-F><SID><C-G>
map <Space> <C-F>
map <C-V> <C-F>
map f <C-F>
map z <C-F>
map <A-Space> <C-F>

" Re-read file and page forward "tail -f"
map F :e<CR>G<SID><C-L>:sleep 1<CR>F

" Scroll half a page forward
noremap <script> <C-D> <C-D><SID><C-G>
map d <C-D>

" Scroll one line forward
noremap <script> <C-E> <C-E><SID><C-G>
map <CR> <C-E>
map <C-N> <C-E>
map <C-J> <C-E>
map e <C-E>
map j <C-E>

" Scroll one page backward
noremap <script> <C-B> <C-B><SID><C-G>
map b <C-B>
map w <C-B>
map <A-v> <C-B>

" Scroll half a page backward
noremap <script> <C-U> <C-U><SID><C-G>
map u <C-U>

" Scroll one line backward
noremap <script> <C-Y> <C-Y><SID><C-G>
map k <C-Y>
map y <C-Y>
map <C-P> <C-Y>
map <C-K> <C-Y>

" Start of file
noremap <script> g gg<SID><C-G>
map < g
map <A-<> g

" End of file
noremap <script> G G<SID><C-G>
map > G
map <A->> G

" Scroll half a page right
noremap <script> <Right> zLg0<SID><C-G>
map <A-)> <Right>

" Scroll half a page left
noremap <script> <Left> zHg0<SID><C-G>
map <A-(> <Left>

" Go to percentage
noremap <script> % %<SID><C-G>
map p %

" Quitting
noremap q :quit<CR>

" Switch to editing (switch off less mode)
noremap v :silent call <SID>End()<CR>
function! s:End()
  set modifiable
  if exists('s:scrolloff')
    let &scrolloff = s:scrolloff
  endif
  if exists('s:shortmess')
    let &shortmess = s:shortmess
  endif
  if exists('s:lazyredraw')
    let &lazyredraw = s:lazyredraw
  endif
  if exists('s:timeoutlen')
    let &timeoutlen = s:timeoutlen
  endif
  autocmd! less
  unmap h
  unmap H
  unmap <SID><C-L>
  unmap <SID><C-G>
  unmap <C-L>
  unmap L
  unmap r
  unmap R
  unmap <C-R>
  unmap l
  unmap t
  unmap <C-F>
  unmap <Space>
  unmap <C-V>
  unmap f
  unmap z
  unmap <A-Space>
  unmap F
  unmap <C-D>
  unmap d
  unmap <C-E>
  unmap <CR>
  unmap <C-N>
  unmap e
  unmap j
  unmap <C-J>
  unmap <C-B>
  unmap b
  unmap w
  unmap <A-v>
  unmap <C-U>
  unmap u
  unmap <C-Y>
  unmap k
  unmap y
  unmap <C-P>
  unmap <C-K>
  unmap g
  unmap <
  unmap <A-<>
  unmap G
  unmap >
  unmap <A->>
  unmap <Right>
  unmap <A-)>
  unmap <Left>
  unmap <A-(>
  unmap %
  unmap p
  unmap q
  unmap v
endfunction

" vim: sw=2 ts=8
