" Based on
runtime colors/grb256.vim

let g:colors_name = "ff256"

hi Comment cterm=italic ctermfg=darkgray

hi VertSplit ctermbg=red ctermfg=lightgrey

hi WarningMsg guifg=white guibg=#FF6C60 gui=BOLD      ctermfg=16  ctermbg=yellow cterm=NONE
hi SpellBad   guifg=red   guibg=NONE    gui=undercurl ctermfg=red ctermbg=NONE   cterm=underline

hi clear CursorLine

hi LineNr ctermfg=DarkGrey
hi CursorLineNR cterm=none ctermfg=Grey

hi ColorColumn cterm=None ctermbg=232 guibg=#080808
hi Error ctermfg=Red ctermbg=none cterm=underline
hi Search ctermbg=DarkCyan ctermfg=White cterm=none
hi SignColumn ctermbg=none

hi SpellCap ctermfg=Yellow ctermbg=none cterm=underline
hi SpellLocal ctermfg=Yellow ctermbg=none cterm=underline
hi VertSplit ctermfg=DarkGrey ctermbg=DarkGrey

hi EndOfBuffer ctermfg=darkgrey guifg=#5f5f5f
hi SpecialKey ctermfg=darkgrey guibg=NONE
hi CursorLineNr gui=NONE
hi StatusLine gui=NONE
hi LineNr guifg=#6c6c6c

hi NonText term=bold ctermfg=238 guifg=#070707 guibg=black

hi ALEErrorSign ctermbg=none ctermfg=Red
hi ALEWarningSign ctermfg=Yellow
hi ALEInfoSign ctermfg=Blue
hi ALEVirtualTextError cterm=italic ctermfg=52
hi ALEVirtualTextWarning cterm=italic ctermfg=94

hi Pmenu ctermbg=234
hi PmenuSbar ctermbg=0
hi PmenuThumb ctermbg=White
