" excerpts from http://d.hatena.ne.jp/ursm/20080908/1220888194
" modified by magicant <magicant.starmen AT nifty.com>
"
" To use this file, put the following line in the [ui] section of ~/.hgrc:
" editor = vim -S <path to this file>

function! Hg_diff_window()
	let regexes = ['^HG: changed \(.*\)$', '^HG: \(.*\) を変更$']
	let files = []
	for line in getline(0, '$')
		for regex in regexes
			let match = matchlist(line, regex)
			if len(match) > 1
				call add(files, match[1])
				break
			endif
		endfor
	endfor
	if len(files) == 0
		return
	end
	call map(files, 'fnameescape(v:val)')

	new
	setlocal filetype=diff bufhidden=delete buftype=nofile previewwindow nobackup noswapfile
	execute 'normal! :0read!hg diff ' . join(files) . "\<CR>\n"
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
