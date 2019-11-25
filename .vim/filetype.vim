augroup filetypedetect
    autocmd BufRead,BufNewFile *mutt-* setfiletype mail
    autocmd BufEnter,BufRead *.conf setfiletype dosini
    autocmd BufEnter,BufRead *.asm setfiletype nasm
    autocmd BufEnter,BufRead *.tsv setfiletype csv
    autocmd BufNewFile,BufRead */.github/workflows/main.yml setfiletype workflow
augroup END
