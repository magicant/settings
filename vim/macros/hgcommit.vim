" excerpts from http://d.hatena.ne.jp/ursm/20080908/1220888194
" modified by magicant <magicant.starmen AT nifty.com>

function! Hg_diff_window()
	let prefix = 'HG: changed '
	let files = map(filter(getline(0, '$'), 'v:val =~ "^" . prefix'), 'fnameescape(strpart(v:val, strlen(prefix)))')

	if len(files) == 0
		return
	end

	new
	setlocal filetype=diff bufhidden=delete buftype=nofile previewwindow nobackup noswapfile
	execute 'normal! :0r!hg diff ' . join(files) . "\<CR>\n"
	$delete
	setlocal nomodifiable
	goto
	redraw
	wincmd R
	wincmd p
	redraw
endfunction

set nowarn
call Hg_diff_window()
