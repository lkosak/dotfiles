" Try to use better color palettej
set t_Co=256

" Load pathogen
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" Basic vim settings
syntax on
set nocompatible
set modelines=0
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
set shell=/bin/sh " work with RVM I guess

" Default indentation settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" textmate style whitespace charts (show tabs and spaces)
set list listchars=tab:▸\ ,trail:· "show trailing whitespace

" Folding settings
set foldmethod=syntax
set foldnestmax=5
set foldlevel=50
set foldcolumn=1

" Disables matchparen -- for performance reasons
let loaded_matchparen = 1
" Don't show character matches (maybe for performance reasons?)
set noshowmatch 

" Friendlier search defaults
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <leader><space> :noh<cr>

" No idea what it does, or where it came from
nnoremap <tab> %
vnoremap <tab> %

" Share mac clipboard
set clipboard+=unnamed

" Ummm... probably from @dorkitude
set selectmode=""
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Use a global backups dir to avoid backup file clutter
set directory=~/.vim/backups

" disable help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" --------------------------------------------------------
" Filetype stuff
" --------------------------------------------------------

" set automatic filetype for *.rabl
autocmd BufNewFile,BufReadPre *.rabl set filetype=ruby

" set automatic filetype for views
autocmd BufRead,BufReadPre ~/Sites/pinchit/application/views/* set filetype=html

" --------------------------------------------------------
" Splits!
" --------------------------------------------------------

" Make new splits/vsplits open below/right of current buffer
set splitbelow
set splitright

" ctrl-based navigation of splits
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j<C-W>_
nnoremap <C-k> <C-w>k<C-W>_

" Set minheights to work with horizontal split navigation
if !&diff
  " we have to have a winheight bigger than we want to set winminheight, but if
  " we set winheight to be huge before winminheight, winminheight set will always
  " fail
  set winheight=5
  set winminheight=5
  set winheight=999
endif

" --------------------------------------------------------
" Editing .vimrc
" --------------------------------------------------------

" leader-v to open vimrc in a split
nmap <leader>v :sp ~/.vimrc<cr>

" Automatically reload vimrc on save
augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
augroup END

" --------------------------------------------------------
" Plugin config
" --------------------------------------------------------

" Setup leader for Ack
nnoremap <leader>a :Ack 

" Setup leader for Commant-T
nmap <leader>f :CommandTFlush<cr>\|:CommandT<cr>

" Fix esc and cursor key navigation in command-t
set ttimeoutlen=50
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

" --------------------------------------------------------
" Ruby test runner
" --------------------------------------------------------

function! RunRailsTest()
  :w " Save file

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

  exec ":!clear && echo 'Running ".file."' && time ruby " . file
endfunction

nmap <leader>t :call RunRailsTest()<cr>
