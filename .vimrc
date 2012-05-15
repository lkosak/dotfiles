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
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
"set undofile

set shell=/bin/sh " work with RVM I guess

" Make new splits/vsplits open below/right of current buffer
set splitbelow
set splitright

set foldmethod=syntax
set foldnestmax=5
set foldlevel=50
set foldcolumn=1
let loaded_matchparen = 1

set ignorecase
set smartcase
set incsearch
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
"map <leader>q :vertical res 30<CR> 

" commandt flush
map <leader>f :CommandTFlush<CR>

" Share mac clipboard
set clipboard+=unnamed

set selectmode=""
set backspace=indent,eol,start whichwrap+=<,>,[,]

set directory=~/.vim/backups

" Use HTML syntax for all views

set noshowmatch

" fast editing of the vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" set automatic filetype for *.rabl
autocmd BufNewFile,BufReadPre *.rabl set filetype=ruby

" set automatic filetype for views
autocmd BufRead,BufReadPre ~/Sites/pinchit/application/views/* set filetype=html

" for insert mode remap <c-l> to:
" Insert a hash rocket  for ruby
" Insert a -> for php
function! SmartHash()
  let ruby = &ft == 'ruby'
  let php = &ft == 'php'

  if php
    return "\->"
  end

  if ruby
    return "\ => "
  end

  return ""
endfunction

imap <c-l> <c-r>=SmartHash()<cr>

function! RunRailsTest()
  let file = expand("%")
  let basepath = getcwd()

  let in_test_file = match(file, '\(.feature\|_spec.rb\|_test.rb\)$') != -1

  if !in_test_file
    " Come up with a best guess search path
    let search_fname = fnamemodify(file, ":s?^app/??:s?.rb$?_spec.rb?")
    " Search for that shit
    let result = globpath(basepath."/spec", "**/".search_fname)

    if empty(result)
      echo "Couldn't locate test file"
      return
    end

    " Get first match (globpath returns a \n separated list)
    let file = split(result, "\n")[0]
    " Make it relative to the current dir (for display purposes)
    let file = fnamemodify(file, ":.")
  end

  exec ":!clear && echo 'Running ".file."' && ruby " . file
endfunction

nmap <leader>r :call RunRailsTest()<cr>
