filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible
set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set encoding=utf-8
set scrolloff=3
set smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
"set undofile

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" textmate style whitespace charts
set list
set listchars=tab:▸\ 

" disable help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap <leader>a :Ack 

" ctrl-based navigation of splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

syntax on

map <leader><tab> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
map <leader>q :vertical res 30<CR> 

" commandt flush
map <leader>f :CommandTFlush<CR>

" Share mac clipboard
set clipboard=unnamed

set selectmode=""
set backspace=indent,eol,start whichwrap+=<,>,[,]

set directory=~/.vim/backups
set directory=~/.vim/backups

" Use HTML syntax for all views
autocmd BufRead,BufNewFile ~/Sites/pinchit/application/views/* set filetype=html

colorscheme molokai
