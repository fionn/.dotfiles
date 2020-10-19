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
set nojoinspaces

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
set lazyredraw

set undofile
set undodir=~/.vim/undodir

set wildmode=longest,list,full
set wildmenu
set wildignore+=*.swp,*.o,*.aux,*.toc,*.pdf,*.so,*.pyc,*/__pycache__,*/venv
set tags+=tags;

" Buffers and Netrw
set hidden
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_special_syntax = 1
let g:netrw_list_hide = '.*\.swp$,.*\.aux$,.*\.toc$,.*\.pdf$,.\*.sig$,.*\.so$,.*\.o$,__pycache__/$,.mypy_cache/$,venv/$,.git/$'
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
filetype indent on
autocmd ColorScheme * highlight SpecialKey ctermfg=238
autocmd InsertLeave * redraw!
autocmd FileType make setlocal noexpandtab softtabstop=0
autocmd FileType csv setlocal noexpandtab softtabstop=0
autocmd FileType tags setlocal tabstop=16 shiftwidth=16 softtabstop=16
autocmd FileType python setlocal completeopt-=preview
autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType gitcommit highlight SpellCap ctermbg=none
autocmd FileType markdown setlocal spell
autocmd FileType markdown highlight Title cterm=bold
autocmd FileType tf setlocal shiftwidth=2
autocmd BufRead /tmp/mutt-* setlocal spell textwidth=72 fo+=watqc
autocmd BufRead /tmp/mutt-* match ErrorMsg '\s\+$'

let g:tex_flavor = "latex"

let b:vcm_tab_complete = "omni"
set omnifunc=syntaxcomplete#Complete

let g:ale_linters = {"tex": ["chktex"]}
let g:ale_lint_on_insert_leave = 1
let g:ale_enabled = 1
let g:ale_virtualenv_dir_names = ["venv"]

let g:ctrlp_extensions = ["tag", "mixed"]

let g:terraform_align=1

set background=dark
colorscheme grb256
set colorcolumn=81
set cursorline
highlight clear CursorLine
highlight colorcolumn ctermbg=232
highlight Error ctermbg=red term=reverse
highlight LineNr ctermfg=darkgrey
highlight Search ctermbg=darkcyan ctermfg=white cterm=none
highlight Comment cterm=italic
highlight CursorLineNR cterm=none ctermfg=grey

nnoremap <F2>:set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

if has("mouse")
    set mouse=a
endif

if has("macunix")
   set backspace=indent,eol,start
   set clipboard=unnamed
   set ruler
   highlight Comment cterm=none
endif

if has("X11")
    autocmd VimLeave * call system("xclip -selection clipboard -r", getreg("+"))
endif

if exists(":cryptmethod")
    set cryptmethod=blowfish2
    autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 secure | endif
endif

"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

cabbrev w!! w !sudo tee > /dev/null %
