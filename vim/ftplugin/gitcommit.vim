" Vim ftplugin file for gitcommit
" Maintainer:  Watanabe, Yuki <magicant.starmen AT nifty.com>
" Last Change: Jun 6, 2011

function! Git_diff_window()
	new
	setlocal filetype=git bufhidden=delete buftype=nofile previewwindow nobackup noswapfile
	execute 'normal! :0read!git diff -p -C --cached --stat=' . &columns . " \<CR>\n"
	$delete
	setlocal nomodifiable
	goto
	redraw
	wincmd R
	wincmd p
	redraw
endfunction

set nowarn
call Git_diff_window()
