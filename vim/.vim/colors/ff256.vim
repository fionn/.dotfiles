" Based on
runtime colors/grb256.vim

let g:colors_name = "ff256"

hi Comment cterm=italic ctermfg=DarkGray

hi VertSplit ctermbg=red ctermfg=LightGrey

hi WarningMsg guifg=white guibg=#FF6C60 gui=BOLD      ctermfg=16  ctermbg=yellow cterm=NONE
hi SpellBad   guifg=red   guibg=NONE    gui=undercurl ctermfg=red ctermbg=NONE   cterm=underline

hi SpellCap ctermfg=Yellow ctermbg=none cterm=underline
hi SpellLocal ctermfg=Yellow ctermbg=none cterm=underline

hi clear CursorLine

hi ColorColumn cterm=None ctermbg=232 guibg=#080808
hi SignColumn ctermbg=none

hi Error ctermfg=Red ctermbg=none cterm=underline
hi Search ctermbg=DarkCyan ctermfg=White cterm=none

hi VertSplit ctermfg=DarkGrey ctermbg=DarkGrey

hi EndOfBuffer ctermfg=DarkGrey guifg=#5f5f5f
hi SpecialKey ctermfg=DarkGrey guibg=NONE
hi NonText term=bold ctermfg=238 guifg=#070707 guibg=black

hi LineNr ctermfg=DarkGrey guifg=#6c6c6c
hi CursorLineNr cterm=none ctermfg=Grey gui=NONE
hi StatusLine gui=NONE

hi ALEErrorSign ctermbg=none ctermfg=Red
hi ALEWarningSign ctermfg=Yellow
hi ALEInfoSign ctermfg=Blue
hi ALEVirtualTextError cterm=italic ctermfg=52
hi ALEVirtualTextWarning cterm=italic ctermfg=94

hi Pmenu ctermbg=234
hi PmenuSbar ctermbg=0
hi PmenuThumb ctermbg=White
