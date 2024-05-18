" Based on
runtime colors/grb256.vim

let g:colors_name = "ff256"

hi Comment cterm=italic ctermfg=darkgray

hi VertSplit ctermbg=red ctermfg=lightgrey

hi WarningMsg guifg=white guibg=#FF6C60 gui=BOLD      ctermfg=16  ctermbg=yellow cterm=NONE
hi SpellBad   guifg=red   guibg=NONE    gui=undercurl ctermfg=red ctermbg=NONE   cterm=underline

highlight clear CursorLine

highlight LineNr ctermfg=DarkGrey
highlight CursorLineNR cterm=none ctermfg=Grey

highlight ColorColumn cterm=None ctermbg=232 guibg=#080808
highlight Error ctermfg=Red ctermbg=none cterm=underline
highlight Search ctermbg=DarkCyan ctermfg=White cterm=none
highlight SignColumn ctermbg=none

highlight SpellCap ctermfg=Yellow ctermbg=none cterm=underline
highlight SpellLocal ctermfg=Yellow ctermbg=none cterm=underline
highlight VertSplit ctermfg=DarkGrey ctermbg=DarkGrey

hi EndOfBuffer ctermfg=darkgrey guifg=#5f5f5f
hi SpecialKey ctermfg=darkgrey guibg=NONE
hi CursorLineNr gui=NONE
hi StatusLine gui=NONE
hi LineNr guifg=#6c6c6c
