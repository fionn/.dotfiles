augroup filetypedetect
    autocmd BufRead,BufNewFile *mutt-* setfiletype mail
    autocmd BufEnter,BufRead *.conf setfiletype confini
    autocmd BufEnter,BufRead *.asm setfiletype nasm
    autocmd BufEnter,BufRead *.tsv setfiletype csv
    autocmd BufEnter,BufRead *.hcl setfiletype terraform
    autocmd BufEnter,BufRead osquery.conf setfiletype jsonc
    autocmd BufEnter,BufRead *.hujson setfiletype jsonc
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
    autocmd FileType go,gomod,gosum set noexpandtab
    autocmd FileType tex syntax sync maxlines=800 | syntax sync minlines=700 | set spell
augroup END
