" Magicant's vim color file
" Maintainer:	Watanabe Yuki aka Magicant <magicant.wonderwand@gmail.com>
" Last Change:	2012 Jan 12

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = expand('<sfile>:t:r')

highlight Normal guifg=LightGray guibg=Black
highlight Comment ctermfg=Blue
highlight Constant ctermfg=174 guifg=#D78787
highlight Cursor cterm=bold ctermfg=Black ctermbg=Green gui=bold guifg=Black guibg=Green
highlight DiffAdd ctermbg=DarkBlue guibg=#000077
highlight DiffChange ctermbg=DarkMagenta guibg=#440055
highlight DiffDelete ctermfg=Black ctermbg=DarkRed guifg=Black guibg=#550000
highlight DiffText ctermbg=Magenta gui=NONE guibg=#9900AA
highlight! link FoldColumn Folded
highlight Folded guifg=Cyan guibg=#555555
highlight Identifier cterm=NONE ctermfg=Cyan guifg=#40FFFF
highlight! link IncSearch Search
highlight LineNr ctermfg=Yellow ctermbg=242 guifg=Yellow guibg=#555555
highlight Pmenu ctermfg=Black ctermbg=Gray guifg=Black guibg=#DDDDDD
highlight PmenuSel ctermfg=Black ctermbg=Green guifg=Black guibg=#70EE70
highlight PmenuSbar ctermbg=Brown guibg=Brown
highlight PmenuThumb cterm=NONE ctermbg=Yellow gui=NONE guibg=Yellow
highlight PreProc ctermfg=177 guifg=#D787FF
highlight SignColumn ctermfg=Red ctermbg=242 guifg=Red guibg=#555555
highlight Special ctermfg=224 guifg=#FFD7D7
highlight Statement cterm=NONE ctermfg=Yellow gui=NONE guifg=#F7F700
highlight StatusLine cterm=bold ctermfg=White ctermbg=Blue gui=bold guifg=White guibg=Blue
highlight Todo ctermfg=White ctermbg=27 guifg=White guibg=#005FFF
highlight Type gui=NONE guifg=#66F566
highlight Visual gui=bold guifg=#333333 guibg=Gray

highlight diffAdded ctermfg=Cyan guifg=Cyan
highlight diffChanged ctermfg=Yellow guifg=Yellow
highlight diffRemoved ctermfg=Red guifg=Red

" for terminals with few colors
if &t_Co <= 16
  highlight Constant ctermfg=Red
  highlight LineNr ctermbg=DarkGray
  highlight PreProc ctermfg=Magenta
  highlight SignColumn ctermbg=DarkGray
  highlight Special cterm=bold
  highlight Todo ctermbg=Blue
endif
