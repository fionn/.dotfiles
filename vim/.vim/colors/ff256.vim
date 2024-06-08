" Based on
runtime colors/grb256.vim

let g:colors_name = "ff256"

hi Normal guifg=NONE guibg=NONE

hi VertSplit ctermbg=red ctermfg=LightGrey

hi WarningMsg guifg=white guibg=#FF6C60 gui=BOLD      ctermfg=16  ctermbg=yellow cterm=NONE
hi SpellBad   guifg=red   guibg=NONE    gui=undercurl ctermfg=red ctermbg=NONE   cterm=underline

hi SpellCap ctermfg=Yellow ctermbg=none cterm=underline
hi SpellLocal ctermfg=Yellow ctermbg=none cterm=underline

hi clear CursorLine

hi ColorColumn cterm=None ctermbg=232 guibg=#080808
hi SignColumn ctermbg=none guibg=NONE

hi Error ctermfg=Red ctermbg=none cterm=underline
hi Search ctermbg=DarkCyan ctermfg=White cterm=none

hi VertSplit ctermfg=DarkGrey ctermbg=DarkGrey

hi EndOfBuffer ctermfg=DarkGrey guifg=#5f5f5f
hi SpecialKey ctermfg=DarkGrey guibg=NONE
hi NonText term=bold ctermfg=238 guifg=#070707 guibg=black

hi LineNr ctermfg=DarkGrey guifg=#6c6c6c
hi CursorLineNr cterm=none ctermfg=Grey gui=NONE guifg=#adadad
hi StatusLine gui=NONE

hi Visual guibg=#2e2e2e

hi Comment cterm=italic ctermfg=DarkGray gui=italic guifg=#6a6a6a
hi Function guifg=#fefb67
hi PreProc guifg=#6871ff
hi Conditional guifg=#6871ff
hi Statement guifg=#5fd7ff cterm=None gui=None
hi Operator guifg=white
hi String guifg=#5ff967
hi Identifier guifg=#5ffdff
hi clear Special
hi link Special Function
hi Delimiter guifg=white

hi Added ctermfg=2 guifg=#009900
hi Changed ctermfg=3 guifg=#bbbb00
hi Removed ctermfg=1 guifg=#ff2222

hi clear Type
hi link Type Function

hi ALEErrorSign ctermbg=none ctermfg=Red
hi ALEWarningSign ctermfg=Yellow
hi ALEInfoSign ctermfg=Blue
hi ALEVirtualTextError cterm=italic ctermfg=52
hi ALEVirtualTextWarning cterm=italic ctermfg=94

hi Pmenu ctermbg=234
hi PmenuSbar ctermbg=0
hi PmenuThumb ctermbg=White

if has("nvim")
    hi link @keyword.import Include
    hi link @type.builtin.python Special
    hi link @function.builtin Function
    hi link @number Number  " No-op
endif
