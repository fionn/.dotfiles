augroup filetypedetect
    autocmd BufRead,BufNewFile *mutt-* setfiletype mail
    autocmd BufEnter,BufRead *.conf setfiletype confini
    autocmd BufEnter,BufRead *.asm setfiletype nasm
    autocmd BufEnter,BufRead *.tsv setfiletype csv
    autocmd BufEnter,BufRead *.hcl setfiletype terraform
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END
