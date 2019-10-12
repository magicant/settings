" Vim ftplugin file for svn-commit.tmp
" Original Creator: Michael Scherer <misc@mandrake.org>
" Maintainer:  Watanabe, Yuki <magicant@wonderwand.net>
" Last Change: Oct 12, 2019

function! Svn_diff_window()
    if !has("windows")
        return
    endif

    let lines = getline(1, '$')
    let files = []
    for line in lines
        if line =~ '^M'
            let file = substitute(line, '\v^MM?\s*(.*)\s*$', '\1', '')
            call add(files, shellescape(file))
        endif
    endfor
    if empty(files)
        return
    endif

    belowright new
    setlocal filetype=diff bufhidden=delete buftype=nofile previewwindow nobackup noswapfile nospell
    execute 'normal! :0read!LANG=C svn diff -- ' . join(files) . "\n"
    $delete
    setlocal nomodifiable
    goto
    redraw
    wincmd p
    redraw
endfunction

set nowarn
call Svn_diff_window()

" vim: et sw=4 sts=4
