vim9script

# https://github.com/habamax/.vim/blob/master/plugin/wl_clipboard.vim

if empty($WAYLAND_DISPLAY)
    finish
endif


def WLYank(event: dict<any>)
    if event.regname =~ '+' || &clipboard =~ '\<unnamed\(plus\)\?\>'
        system('wl-copy', getreg("@"))
    endif
enddef


def WLPaste(pasteCmd: string)
    setreg("@", system('wl-paste --no-newline')->substitute('\r', '', 'g'))
    exe 'normal! ""' .. pasteCmd
enddef


augroup WLYank | autocmd!
    autocmd TextYankPost * call WLYank(v:event)
augroup END


if &clipboard =~ '\<unnamed\(plus\)\?\>'
    xnoremap p <ScriptCmd>WLPaste("p")<CR>
    xnoremap P <ScriptCmd>WLPaste("P")<CR>
    nnoremap p <ScriptCmd>WLPaste("p")<CR>
    nnoremap P <ScriptCmd>WLPaste("P")<CR>
endif

xnoremap "+p <ScriptCmd>WLPaste("p")<CR>
xnoremap "+P <ScriptCmd>WLPaste("P")<CR>
xnoremap "*p <ScriptCmd>WLPaste("p")<CR>
xnoremap "*P <ScriptCmd>WLPaste("P")<CR>
nnoremap "+p <ScriptCmd>WLPaste("p")<CR>
nnoremap "+P <ScriptCmd>WLPaste("P")<CR>
nnoremap "*p <ScriptCmd>WLPaste("p")<CR>
nnoremap "*P <ScriptCmd>WLPaste("P")<CR>

inoremap <C-r>+ <ScriptCmd>WLPaste("p")<CR><Cmd>normal! `]<CR><Right>
imap <C-r>* <C-r>+
