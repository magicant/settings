" Vim script to work like "less"
" Based on Bram's script.
" Author:  Watanabe Yuki <magicant.starmen@nifty.com>

if exists("loaded_less")
  finish
endif
let loaded_less = 1

set nocompatible
syntax on
set scrolloff=999
set hlsearch
nohlsearch
" Don't remember file names and positions
set viminfo= noswapfile
set nowrapscan
" Inhibit screen updates while searching
let s:lz = &lz
set lazyredraw
set startofline

augroup less

" Used after each command: put cursor at end and display position
if &wrap
  noremap <SID>L 0:redraw<CR>:file<CR>
  autocmd VimEnter * normal! 0
else
  noremap <SID>L g0:redraw<CR>:file<CR>
  autocmd VimEnter * normal! g0
endif

" When reading from stdin don't consider the file modified.
autocmd VimEnter * set nomodified

" Always start at the beginning of the file.
autocmd BufEnter * goto

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
  echo ":n<Enter> Next file                 :p<Enter> Previous file"
  echo "\n"
  echo "q         Quit                      v         Edit file"
endfunction

" Scroll one page forward
noremap <script> <C-F> <C-F><SID>L
map <Space> <C-F>
map <C-V> <C-F>
map f <C-F>
map z <C-F>
map <Esc><Space> <C-F>

" Re-read file and page forward "tail -f"
map F :e<CR>G<SID>L:sleep 1<CR>F

" Scroll half a page forward
noremap <script> <C-D> <C-D><SID>L
map d <C-D>

" Scroll one line forward
noremap <script> <C-E> <C-E><SID>L
map <CR> <C-E>
map <C-N> <C-E>
map <C-J> <C-E>
map e <C-E>
map j <C-E>

" Scroll one page backward
noremap <script> <C-B> <C-B><SID>L
map b <C-B>
map w <C-B>
map <Esc>v <C-B>

" Scroll half a page backward
noremap <script> <C-U> <C-U><SID>L
map u <C-U>

" Scroll one line backward
noremap <script> <C-Y> <C-Y><SID>L
map k <C-Y>
map y <C-Y>
map <C-P> <C-Y>
map <C-K> <C-Y>

" Redraw
noremap <script> L <SID>L
map r L
map R L
map <C-R> L
map <C-L> L

" Start of file
noremap <script> g gg<SID>L
map < g
map <Esc>< g

" End of file
noremap <script> G G<SID>L
map > G
map <Esc>> G

" Go to percentage
noremap <script> % %<SID>L
map p %

" Search
noremap <script> / $:call <SID>Forward()<CR>/
if &wrap
  noremap <script> ? 0:call <SID>Backward()<CR>?
else
  noremap <script> ? g0:call <SID>Backward()<CR>?
endif

function! s:Forward()
  " Searching forward
  noremap <script> n $nzz<SID>L
  if &wrap
    noremap <script> N 0Nzz<SID>L
  else
    noremap <script> N g0Nzz<SID>L
  endif
  cnoremap <script> <CR> <CR>:cunmap <lt>CR><CR>zz<SID>L
endfunction

function! s:Backward()
  " Searching backward
  if &wrap
    noremap <script> n 0nzt<SID>L
  else
    noremap <script> n g0nzt<SID>L
  endif
  noremap <script> N $Nzt<SID>L
  cnoremap <script> <CR> <CR>:cunmap <lt>CR><CR>zz<SID>L
endfunction

call s:Forward()

" Quitting
noremap q ZZ

" Switch to editing (switch off less mode)
map v :silent call <SID>End()<CR>
function! s:End()
  set modifiable
  if exists('s:lz')
    let &lz = s:lz
  endif
  autocmd! less
  unmap h
  unmap H
  unmap <Space>
  unmap <C-V>
  unmap f
  unmap <C-F>
  unmap z
  unmap <Esc><Space>
  unmap F
  unmap d
  unmap <C-D>
  unmap <CR>
  unmap <C-N>
  unmap e
  unmap <C-E>
  unmap j
  unmap <C-J>
  unmap b
  unmap <C-B>
  unmap w
  unmap <Esc>v
  unmap u
  unmap <C-U>
  unmap k
  unmap y
  unmap <C-Y>
  unmap <C-P>
  unmap <C-K>
  unmap r
  unmap <C-R>
  unmap R
  unmap g
  unmap <
  unmap <Esc><
  unmap G
  unmap >
  unmap <Esc>>
  unmap %
  unmap p
  unmap n
  unmap N
  unmap q
  unmap v
  unmap /
  unmap ?
endfunction

" vim: sw=2 ts=8
