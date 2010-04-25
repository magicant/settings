" Vim script to make Vim work like "less"
" Based on Bram's script.
" Author:  Watanabe Yuki <magicant.starmen AT nifty.com>

command! -nargs=? -complete=file View call Vimless(<f-args>)

function Vimless(...)

  " Open the specified file
  if a:0 > 0
    execute "view +1 " . fnameescape(a:1)
  endif

  " Don't use swapfile
  setlocal noswapfile

  " Don't allow modifying/writing the text
  setlocal nomodifiable readonly

  " Open folds
  if has("folding")
    setlocal nofoldenable
  endif

  " Give help
  noremap <buffer> h :call <SID>Help()<CR>

  " Redraw
  noremap <buffer> <script> <SID><C-G> :call <SID>Redraw()<CR>
  noremap <buffer> <script> <C-L> <SID><C-G>
  map <buffer> <C-R> <C-L>
  map <buffer> L <C-L>
  map <buffer> r <C-L>
  map <buffer> R <C-L>

  " Scroll one page forward
  noremap <buffer> <script> <C-F> <C-F><SID><C-G>
  map <buffer> <Space> <C-F>
  map <buffer> <PageDown> <C-F>
  map <buffer> <S-Down> <C-F>
  map <buffer> <C-V> <C-F>
  map <buffer> f <C-F>

  " Re-read file and page forward "tail -f"
  noremap <buffer> <script> <SID>F :edit<CR>G<SID><C-G>gs<SID>F
  noremap <buffer> <script> F <SID>F

  " Scroll half a page forward
  noremap <buffer> <script> <C-D> <C-D><SID><C-G>
  map <buffer> d <C-D>

  " Scroll one line forward
  noremap <buffer> <script> <C-E> <C-E><SID><C-G>
  map <buffer> <Down> <C-E>
  map <buffer> <CR> <C-E>
  map <buffer> <C-M> <C-E>
  map <buffer> <C-N> <C-E>
  map <buffer> <C-J> <C-E>
  map <buffer> e <C-E>
  map <buffer> j <C-E>
  map <buffer> + <C-E>

  " Scroll one page backward
  noremap <buffer> <script> <C-B> <C-B><SID><C-G>
  map <buffer> <PageUp> <C-B>
  map <buffer> <S-Up> <C-B>
  map <buffer> b <C-B>
  map <buffer> <A-v> <C-B>

  " Scroll half a page backward
  noremap <buffer> <script> <C-U> <C-U><SID><C-G>
  map <buffer> u <C-U>

  " Scroll one line backward
  noremap <buffer> <script> <C-Y> <C-Y><SID><C-G>
  map <buffer> <Up> <C-Y>
  map <buffer> <C-P> <C-Y>
  map <buffer> <C-K> <C-Y>
  map <buffer> k <C-Y>
  map <buffer> y <C-Y>
  map <buffer> - <C-Y>

  " Start of file
  noremap <buffer> <script> gg gg<SID><C-G>
  map <buffer> <Home> gg
  map <buffer> <C-Home> gg
  map <buffer> < gg
  map <buffer> <A-<> gg

  " End of file
  noremap <buffer> <script> G G<SID><C-G>
  map <buffer> <End> G
  map <buffer> <C-End> G
  map <buffer> > G
  map <buffer> <A->> G

  " Scroll half a page right
  noremap <buffer> <script> <Right> zL<SID><C-G>
  map <buffer> <A-)> <Right>

  " Scroll half a page left
  noremap <buffer> <script> <Left> zH<SID><C-G>
  map <buffer> <A-(> <Left>

  " Go to percentage
  noremap <buffer> <script> % %<SID><C-G>
  map <buffer> p %

  " Quitting
  noremap <buffer> q :quit<CR>

  " Switch to editing (switch off less mode)
  noremap <buffer> v :call <SID>End()<CR>

endfunction

function s:Redraw()
  let a:startofline = &startofline
  set nostartofline
  normal! Mg0
  let &startofline = a:startofline
  redraw
  file
endfunction

function s:Help()
  echo "<Space>   One page forward          b         One page backward"
  echo "d         Half a page forward       u         Half a page backward"
  echo "<Enter>   One line forward          k         One line backward"
  echo "G         End of file               gg        Start of file"
  echo "N%        percentage in file"
  echo "q         Quit                      v         Exit less mode"
endfunction

function s:End()
  setlocal modifiable& readonly&
  mapclear <buffer>
  augroup less
    autocmd!
  augroup END
endfunction

" vim: sw=2 ts=8
