" Vim script to read directory-specific configuration on startup
" Based on http://www.vim.org/scripts/script.php?script_id=1408
" Author:  Watanabe Yuki <magicant AT wonderwand.net>
" License: Vim License

function s:ReadDirectoryLocalConfiguration(dir)
  if a:dir =~# "/$"
    let vimrc = a:dir . ".lvimrc"
  else
    let vimrc = a:dir . "/.lvimrc"
  endif

  if filereadable(vimrc)
    execute "source " . vimrc
    return
  endif

  let newdir = fnamemodify(a:dir, ":h")
  if newdir !=# a:dir
    call s:ReadDirectoryLocalConfiguration(newdir)
  endif
endfunction

call s:ReadDirectoryLocalConfiguration(getcwd())

" vim: sw=2 ts=8
