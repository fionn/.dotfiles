set secure
set nocompatible
set encoding=utf-8

noremap <leader>s :source ~/.vimrc<CR>
nnoremap Q <Nop>
nnoremap <silent><CR> :nohlsearch<CR><CR>
nnoremap <leader>u :UndotreeToggle<CR>
onoremap j gj
onoremap k gk
command W w
command Q q
command Wq wq

set clipboard=unnamedplus
set number
set tabstop=4
set shiftwidth=4
set softtabstop=-1
"set smarttab
set expandtab
set shiftround
set autoindent
"set smartindent
set breakindent
"set shortmess+=I

set ignorecase
set smartcase
set incsearch
set hlsearch

"set laststatus=2
set spelllang=en_gb
set showcmd
set wrap
set linebreak
set ttyfast

set undofile
set undodir=~/.vim/undodir

set wildmode=longest,list,full
set wildmenu
set wildignore+=*.swp,*.o,*.aux,*.toc,*.pdf,*.so
set tags+=tags;

" Buffers and Netrw
set hidden
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_special_syntax = 1
let g:netrw_list_hide = '.*\.swp$,.*\.aux$,.*\.toc$,.*\.pdf$,.\*.sig$,.*\.so$,.*\.o$,__pycache__/$,.mypy_cache/$'
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" vim-jedi is managed by pacman
" requires python-jedi
"let g:jedi#popup_on_dot = 0
"let g:jedi#show_call_signatures = 2
"let g:jedi#smart_auto_mappings = 0
"let g:jedi#auto_vim_configuration = 0
set completeopt=longest,menu,preview

syntax on
set list listchars=tab:\ \ ,trail:·
autocmd ColorScheme * highlight SpecialKey ctermfg=238
autocmd InsertLeave * redraw!
filetype indent on
autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0
autocmd FileType tags setlocal tabstop=16 shiftwidth=16 softtabstop=16
autocmd FileType python setlocal completeopt-=preview
autocmd FileType gitcommit setlocal spell
autocmd BufEnter,BufRead *.conf setf dosini

let b:vcm_tab_complete = 'omni'
set omnifunc=syntaxcomplete#Complete

let g:ale_linters = {"python": ["pylint", "mypy"], "tex": ["chktex"]}
let g:ale_lint_on_insert_leave = 1
let g:ale_enabled = 1

set t_Co=256
set background=dark
color grb256
set colorcolumn=81
highlight colorcolumn ctermbg=232
highlight Error ctermbg=red term=reverse
highlight LineNr ctermfg=darkgrey
highlight Search ctermbg=darkcyan ctermfg=white cterm=none
highlight Comment cterm=italic
set cursorline
highlight clear CursorLine
highlight CursorLineNR ctermfg=grey

nnoremap <F2>:set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

if has('mouse')
    set mouse=a
endif

if has("macunix")
   set backspace=indent,eol,start
   set clipboard=unnamed
   set ruler
   highlight Comment cterm=none
endif

au BufRead /tmp/mutt-* set textwidth=72

if exists(":cryptmethod")
    set cryptmethod=blowfish2
    autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 secure | endif
endif

"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

cabbrev w!! w !sudo tee > /dev/null %

