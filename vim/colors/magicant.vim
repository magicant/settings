" Magicant's vim color file
" Maintainer:   Watanabe Yuki aka Magicant <magicant.wonderwand@gmail.com>
" Last Change:  May 1, 2020

set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
if has("eval")
    let g:colors_name = expand('<sfile>:t:r')
endif

highlight Normal guifg=LightGray guibg=Black
highlight Comment ctermfg=Blue
highlight Constant ctermfg=174 guifg=#D78787
highlight Cursor cterm=bold ctermfg=Black ctermbg=Green gui=bold guifg=Black guibg=LightGreen
highlight DiffAdd ctermbg=23 guibg=#112A33
highlight DiffChange ctermbg=58 guibg=#2A3311
highlight DiffDelete ctermfg=Black ctermbg=53 guifg=Black guibg=#33112A
highlight DiffText cterm=NONE ctermbg=94 gui=NONE guibg=#664422
highlight! link FoldColumn Folded
highlight Folded ctermfg=White ctermbg=242 guifg=White guibg=#555555
highlight Identifier cterm=NONE ctermfg=Cyan guifg=#40FFFF
highlight! link IncSearch Search
highlight LineNr ctermfg=Yellow ctermbg=242 guifg=Yellow guibg=#555555
highlight NonText term=NONE ctermfg=Blue gui=Bold guifg=#2222BB
highlight Pmenu ctermfg=Black ctermbg=Gray guifg=Black guibg=#DDDDDD
highlight PmenuSel ctermfg=Black ctermbg=Green guifg=Black guibg=#70EE70
highlight PmenuSbar ctermbg=Brown guibg=Brown
highlight PmenuThumb cterm=NONE ctermbg=Yellow gui=NONE guibg=Yellow
highlight PreProc ctermfg=177 guifg=#D787FF
highlight SignColumn ctermfg=Red ctermbg=242 guifg=Red guibg=#555555
highlight Special ctermfg=224 guifg=#FFD7D7
highlight SpecialKey ctermfg=Brown guifg=#996600
highlight SpellBad ctermbg=88
highlight SpellCap ctermbg=19 gui=undercurl guisp=#00AAFF
highlight SpellLocal ctermbg=24
highlight SpellRare ctermbg=90
highlight Statement cterm=NONE ctermfg=Yellow gui=NONE guifg=#F7F700
highlight StatusLine cterm=bold ctermfg=White ctermbg=Blue gui=bold guifg=White guibg=Blue
highlight StatusLineNC term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
highlight StatusLineTerm cterm=bold ctermfg=White ctermbg=DarkGreen gui=bold guifg=White guibg=DarkGreen
highlight StatusLineTermNC term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
highlight Todo ctermfg=White ctermbg=27 guifg=White guibg=#005FFF
highlight Type gui=NONE guifg=#66F566
highlight Visual gui=bold guifg=#333333 guibg=LightGray

highlight diffAdded ctermfg=Cyan guifg=Cyan
highlight diffChanged ctermfg=Yellow guifg=Yellow
highlight diffRemoved ctermfg=Red guifg=Red

" for terminals with few colors
if &t_Co <= 16
    highlight Constant ctermfg=Red
    highlight DiffAdd ctermbg=DarkBlue
    highlight DiffChange ctermbg=DarkMagenta
    highlight DiffDelete ctermbg=DarkRed
    highlight DiffText ctermbg=Magenta
    highlight Folded ctermbg=DarkGray
    highlight LineNr ctermbg=DarkGray
    highlight PreProc ctermfg=Magenta
    highlight SignColumn ctermbg=DarkGray
    highlight Special cterm=bold
    highlight SpellBad ctermbg=DarkRed
    highlight SpellCap ctermbg=DarkBlue
    highlight SpellLocal ctermbg=DarkCyan
    highlight SpellRare ctermbg=DarkMagenta
    highlight Todo ctermbg=Blue
endif

" vim: et sw=4 sts=4
