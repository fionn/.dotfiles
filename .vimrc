set nocompatible

"set runtimepath=/home/fionn/.vim,$VIMRUNTIME " grb256 for root

noremap <leader>s :source ~/.vimrc<CR>
nnoremap Q <Nop>
command Q q
command W w

set nu
set ts=4
set shiftwidth=4
"set softtabstop=4
"set smarttab
set expandtab
set shiftround
set autoindent
"set smartindent
"set shortmess+=I

set smartcase
set incsearch

"set laststatus=2
set spelllang=en_gb
"set cursorline " makes errors impossible to read, https://vi.stackexchange.com/q/3288
set showcmd

" Buffers and Netrw
set hidden
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_altv = 1
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

set wrap
set linebreak
set ttyfast

onoremap j gj 
onoremap k gk

set wildmode=longest,list,full
set wildmenu
set wildignore+=.git,*.swp,*.o,*.aux,*.toc,*.pdf

let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2
let g:jedi#smart_auto_mappings = 0
let g:jedi#auto_vim_configuration = 0
set completeopt=longest,menu,preview

syntax on
"filetype plugin indent on 
filetype indent on
autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0
autocmd FileType python setlocal completeopt-=preview

let b:vcm_tab_complete = 'omni'
set omnifunc=syntaxcomplete#Complete
"au FileType css setl ofu=csscomplete#CompleteCSS
"autocmd BufNewFile,BufRead *.scss set ft=scss.css

set t_Co=256
set background=dark
color grb256
highlight colorcolumn ctermbg=232
"let &colorcolumn=join(range(81,999),",")
set colorcolumn=81
highlight Error ctermbg=red term=reverse
highlight LineNr ctermfg=darkgrey

set undofile
set undodir=~/.vim/undodir

nnoremap <F2>:set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

if has('mouse')
	set mouse=a
endif

au BufRead /tmp/mutt-* set tw=72

set cryptmethod=blowfish2
autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 secure | endif

"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

"cmap w!! w !sudo tee > /dev/null %
cabbrev w!! w !sudo tee > /dev/null %

