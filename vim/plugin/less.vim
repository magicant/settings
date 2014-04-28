" Vim script to make Vim work like "less"
" Based on Bram's script.
" Author:  Watanabe Yuki <magicant.starmen AT nifty.com>
" License: Vim License

if exists("loaded_vimless")
  finish
elseif !exists("s:loaded")
  let s:loaded = 1
  command -nargs=? -complete=file View call Vimless(<f-args>)
  execute 'autocmd FuncUndefined Vimless source ' . fnameescape(expand('<sfile>'))
  finish
endif
let loaded_vimless = 1


noremap <script> <SID><F1>    :call <SID>Help()<CR>
noremap <script> <SID>M       :call <SID>MiddleRedraw()<CR>
noremap <script> <SID><C-G>   :call <SID>Redraw()<CR>
noremap <script> <SID><C-F>   <C-F><SID>M
noremap <script> <SID>F       :edit<CR>G<SID><C-G>gs<SID>F
noremap <script> <SID><C-D>   <C-D><SID>M
noremap <script> <SID><C-E>   <C-E><SID>M
noremap <script> <SID><C-B>   <C-B><SID>M
noremap <script> <SID><C-U>   <C-U><SID>M
noremap <script> <SID><C-Y>   <C-Y><SID>M
noremap <script> <SID>gg      gg<SID><C-G>
noremap <script> <SID>G       G<SID><C-G>
noremap <script> <SID><Right> zL<SID>M
noremap <script> <SID><Left>  zH<SID>M
noremap <script> <SID>%       %<SID>M
noremap <script> <SID>q       :quit<CR>
noremap <script> <SID>v       :call <SID>End()<CR>


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
  noremap <buffer> <script> h <SID><F1>

  " Redraw
  noremap <buffer> <script> <C-G> <SID><C-G>
  noremap <buffer> <script> <C-L> <SID><C-G>
  noremap <buffer> <script> <C-R> <SID><C-G>
  noremap <buffer> <script> L     <SID><C-G>
  noremap <buffer> <script> r     <SID><C-G>
  noremap <buffer> <script> R     <SID><C-G>
  noremap <buffer> <script> =     <SID><C-G>

  " Scroll one page forward
  noremap <buffer> <script> <C-F>      <SID><C-F>
  noremap <buffer> <script> <Space>    <SID><C-F>
  noremap <buffer> <script> <PageDown> <SID><C-F>
  noremap <buffer> <script> <S-Down>   <SID><C-F>
  noremap <buffer> <script> <C-V>      <SID><C-F>
  noremap <buffer> <script> f          <SID><C-F>

  " Re-read file and page forward "tail -f"
  noremap <buffer> <script> F <SID>F

  " Scroll half a page forward
  noremap <buffer> <script> <C-D> <SID><C-D>
  noremap <buffer> <script> d     <SID><C-D>

  " Scroll one line forward
  noremap <buffer> <script> <C-E>  <SID><C-E>
  noremap <buffer> <script> <Down> <SID><C-E>
  noremap <buffer> <script> <CR>   <SID><C-E>
  noremap <buffer> <script> <C-M>  <SID><C-E>
  noremap <buffer> <script> <C-N>  <SID><C-E>
  noremap <buffer> <script> <C-J>  <SID><C-E>
  noremap <buffer> <script> e      <SID><C-E>
  noremap <buffer> <script> j      <SID><C-E>
  noremap <buffer> <script> +      <SID><C-E>

  " Scroll one page backward
  noremap <buffer> <script> <C-B>     <SID><C-B>
  noremap <buffer> <script> <PageUp>  <SID><C-B>
  noremap <buffer> <script> <S-Space> <SID><C-B>
  noremap <buffer> <script> <S-Up>    <SID><C-B>
  noremap <buffer> <script> b         <SID><C-B>
  noremap <buffer> <script> <A-v>     <SID><C-B>

  " Scroll half a page backward
  noremap <buffer> <script> <C-U> <SID><C-U>
  noremap <buffer> <script> u     <SID><C-U>

  " Scroll one line backward
  noremap <buffer> <script> <C-Y> <SID><C-Y>
  noremap <buffer> <script> <Up>  <SID><C-Y>
  noremap <buffer> <script> <C-P> <SID><C-Y>
  noremap <buffer> <script> <C-K> <SID><C-Y>
  noremap <buffer> <script> k     <SID><C-Y>
  noremap <buffer> <script> y     <SID><C-Y>
  noremap <buffer> <script> -     <SID><C-Y>

  " Start of file
  noremap <buffer> <script> gg       <SID>gg
  noremap <buffer> <script> <Home>   <SID>gg
  noremap <buffer> <script> <C-Home> <SID>gg
  noremap <buffer> <script> <        <SID>gg
  noremap <buffer> <script> <A-<>    <SID>gg

  " End of file
  noremap <buffer> <script> G       <SID>G
  noremap <buffer> <script> <End>   <SID>G
  noremap <buffer> <script> <C-End> <SID>G
  noremap <buffer> <script> >       <SID>G
  noremap <buffer> <script> <A->>   <SID>G

  " Scroll half a page right
  noremap <buffer> <script> <Right> <SID><Right>
  noremap <buffer> <script> <A-)>   <SID><Right>

  " Scroll half a page left
  noremap <buffer> <script> <Left> <SID><Left>
  noremap <buffer> <script> <A-(>  <SID><Left>

  " Go to percentage
  noremap <buffer> <script> % <SID>%
  noremap <buffer> <script> p <SID>%

  " Quitting
  noremap <buffer> <script> q <SID>q
  noremap <buffer> <script> Q <SID>q

  " Switch to editing (switch off less mode)
  noremap <buffer> <script> v <SID>v

endfunction

function s:MiddleRedraw()
  let l:startofline = &startofline
  set nostartofline
  keepjumps normal! Mg0
  let &startofline = l:startofline
  call s:Redraw()
endfunction

function s:Redraw()
  redraw
  echo '-- VIMLESS --'
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
  setlocal swapfile& modifiable& readonly&
  mapclear <buffer>
  augroup less
    autocmd!
  augroup END
  call s:Redraw()
endfunction

" vim: sw=2 ts=8
