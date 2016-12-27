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


noremap <script> <special> <SID><F1>    :call <SID>Help()<CR>
noremap <script> <special> <SID>M       :call <SID>MiddleRedraw()<CR>
noremap <script> <special> <SID><C-G>   :call <SID>Redraw()<CR>
noremap <script> <special> <SID><C-F>   <C-F><SID>M
noremap <script> <special> <SID>F       :edit<CR>G<SID><C-G>gs<SID>F
noremap <script> <special> <SID><C-D>   <C-D><SID>M
noremap <script> <special> <SID><C-E>   <C-E><SID>M
noremap <script> <special> <SID><C-B>   <C-B><SID>M
noremap <script> <special> <SID><C-U>   <C-U><SID>M
noremap <script> <special> <SID><C-Y>   <C-Y><SID>M
noremap <script> <special> <SID>gg      gg<SID><C-G>
noremap <script> <special> <SID>G       G<SID><C-G>
noremap <script> <special> <SID><Right> zL<SID>M
noremap <script> <special> <SID><Left>  zH<SID>M
noremap <script> <special> <SID>%       %<SID>M
noremap <script> <special> <SID>q       :quit<CR>
noremap <script> <special> <SID>v       :call <SID>End()<CR>


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
    nnoremap <buffer> <nowait> <script> <special> h <SID><F1>

    " Redraw
    nnoremap <buffer> <nowait> <script> <special> <C-G> <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> <C-L> <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> <C-R> <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> L     <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> r     <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> R     <SID><C-G>
    nnoremap <buffer> <nowait> <script> <special> =     <SID><C-G>

    " Scroll one page forward
    nnoremap <buffer> <nowait> <script> <special> <C-F>      <SID><C-F>
    nnoremap <buffer> <nowait> <script> <special> <Space>    <SID><C-F>
    nnoremap <buffer> <nowait> <script> <special> <PageDown> <SID><C-F>
    nnoremap <buffer> <nowait> <script> <special> <S-Down>   <SID><C-F>
    nnoremap <buffer> <nowait> <script> <special> <C-V>      <SID><C-F>
    nnoremap <buffer> <nowait> <script> <special> f          <SID><C-F>

    " Re-read file and page forward "tail -f"
    nnoremap <buffer> <nowait> <script> <special> F <SID>F

    " Scroll half a page forward
    nnoremap <buffer> <nowait> <script> <special> <C-D> <SID><C-D>
    nnoremap <buffer> <nowait> <script> <special> d     <SID><C-D>

    " Scroll one line forward
    nnoremap <buffer> <nowait> <script> <special> <C-E>  <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> <Down> <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> <CR>   <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> <C-M>  <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> <C-N>  <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> <C-J>  <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> e      <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> j      <SID><C-E>
    nnoremap <buffer> <nowait> <script> <special> +      <SID><C-E>

    " Scroll one page backward
    nnoremap <buffer> <nowait> <script> <special> <C-B>     <SID><C-B>
    nnoremap <buffer> <nowait> <script> <special> <PageUp>  <SID><C-B>
    nnoremap <buffer> <nowait> <script> <special> <S-Space> <SID><C-B>
    nnoremap <buffer> <nowait> <script> <special> <S-Up>    <SID><C-B>
    nnoremap <buffer> <nowait> <script> <special> b         <SID><C-B>
    nnoremap <buffer> <nowait> <script> <special> <A-v>     <SID><C-B>

    " Scroll half a page backward
    nnoremap <buffer> <nowait> <script> <special> <C-U> <SID><C-U>
    nnoremap <buffer> <nowait> <script> <special> u     <SID><C-U>

    " Scroll one line backward
    nnoremap <buffer> <nowait> <script> <special> <C-Y> <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> <Up>  <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> <C-P> <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> <C-K> <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> k     <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> y     <SID><C-Y>
    nnoremap <buffer> <nowait> <script> <special> -     <SID><C-Y>

    " Start of file
    nnoremap <buffer> <nowait> <script> <special> gg       <SID>gg
    nnoremap <buffer> <nowait> <script> <special> <Home>   <SID>gg
    nnoremap <buffer> <nowait> <script> <special> <C-Home> <SID>gg
    nnoremap <buffer> <nowait> <script> <special> <        <SID>gg
    nnoremap <buffer> <nowait> <script> <special> <A-<>    <SID>gg

    " End of file
    nnoremap <buffer> <nowait> <script> <special> G       <SID>G
    nnoremap <buffer> <nowait> <script> <special> <End>   <SID>G
    nnoremap <buffer> <nowait> <script> <special> <C-End> <SID>G
    nnoremap <buffer> <nowait> <script> <special> >       <SID>G
    nnoremap <buffer> <nowait> <script> <special> <A->>   <SID>G

    " Scroll half a page right
    nnoremap <buffer> <nowait> <script> <special> <Right> <SID><Right>
    nnoremap <buffer> <nowait> <script> <special> <A-)>   <SID><Right>

    " Scroll half a page left
    nnoremap <buffer> <nowait> <script> <special> <Left> <SID><Left>
    nnoremap <buffer> <nowait> <script> <special> <A-(>  <SID><Left>

    " Go to percentage
    nnoremap <buffer> <nowait> <script> <special> % <SID>%
    nnoremap <buffer> <nowait> <script> <special> p <SID>%

    " Quitting
    nnoremap <buffer> <nowait> <script> <special> q <SID>q
    nnoremap <buffer> <nowait> <script> <special> Q <SID>q

    " Switch to editing (switch off less mode)
    nnoremap <buffer> <nowait> <script> <special> v <SID>v

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
    redraw
    file
endfunction

" vim: et sw=4 sts=4
