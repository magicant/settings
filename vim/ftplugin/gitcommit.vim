" Vim ftplugin file for gitcommit
" Maintainer:  Watanabe, Yuki <magicant@wonderwand.net>
" Last Change: Mar 23, 2019

function! Git_diff_window()
    if !has("windows")
        return
    endif
    if search("------------------------ >8 ------------------------", "nw")
        return
    endif
    belowright new
    setlocal filetype=git bufhidden=delete buftype=nofile previewwindow nobackup noswapfile nospell
    execute 'normal! :0read!git diff -p -C --cached --stat=' . &columns . " \<CR>\n"
    $delete
    setlocal nomodifiable
    goto
    redraw
    wincmd p
    redraw
endfunction

set nowarn
call Git_diff_window()

" vim: et sw=4 sts=4
