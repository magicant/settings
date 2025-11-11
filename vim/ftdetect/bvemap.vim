" detect bvemap file

autocmd BufRead,BufNewFile * call s:DetectTypeBveMap()

function! s:DetectTypeBveMap()
    if did_filetype() && &filetype != "text"
        return
    endif

    if getline(1) =~? "^bvets map 2"
        set filetype=bvemap
    endif
endfunction

" vim: et sw=4 sts=4
