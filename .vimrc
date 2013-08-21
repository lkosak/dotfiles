" Try to use better color palette
set t_Co=256
set bg=dark
colorscheme solarized

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
set noerrorbells
set ttyfast
set ruler
set laststatus=2
set number
set shell=/bin/sh " work with RVM I guess

" More human backspace behavior
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Default indentation settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set colorcolumn=80

" textmate style whitespace charts (show tabs and spaces)
set list listchars=tab:▸\ ,trail:· "show trailing whitespace

" disable ctags searching
let g:Tlist_Ctags_Cmd = 'ctags'

" Folding settings
set nofoldenable

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

" Use tab to jump between opening and closing characters
nnoremap <tab> %
vnoremap <tab> %

" Ummm... probably from @dorkitude
set selectmode=""

" Use a global backups dir to avoid backup file clutter
set directory=~/.vim/backups

" disable help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Solarized bg flipper
" call togglebg#map("<F5>")

" --------------------------------------------------------
" Filetype stuff
" --------------------------------------------------------

" set automatic filetype for *.rabl
autocmd BufNewFile,BufReadPre *.rabl set filetype=ruby
" set automatic filetype for views
autocmd BufRead,BufReadPre ~/Sites/pinchit/application/views/* set filetype=html
autocmd BufNewFile,BufReadPre *.sass set filetype=sass
autocmd BufNewFile,BufReadPre *.hamlc set filetype=haml
autocmd BufNewFile,BufReadPre *.hamstache set filetype=haml
autocmd BufNewFile,BufReadPre *.erb set filetype=html

" --------------------------------------------------------
" Jump to last line edited when re-opening files
" --------------------------------------------------------

" if has("autocmd")
"   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
"     \| exe "normal g'\"" | endif
" endif

" --------------------------------------------------------
" Splits!
" --------------------------------------------------------

" Make new splits/vsplits open below/right of current buffer
set splitbelow
set splitright

" ctrl-based navigation of splits
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Set minheights to work with horizontal split navigation
" if !&diff
"   " we have to have a winheight bigger than we want to set winminheight, but if
"   " we set winheight to be huge before winminheight, winminheight set will always
"   " fail
"   set winheight=5
"   set winminheight=5
"   set winheight=999
" endif

" --------------------------------------------------------
" Navigation
" --------------------------------------------------------

" These don't seem to work :(
" nmap <M-h> :tabprevious<CR>
" nmap <M-l> :tabnext<CR>

" --------------------------------------------------------
" Editing .vimrc
" --------------------------------------------------------

" leader-v to open vimrc in a split
nmap <leader>ev :sp ~/.vimrc<cr>

" Automatically reload vimrc on save
augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc nested source ~/.vimrc
augroup END

" --------------------------------------------------------
" Plugin config
" --------------------------------------------------------

" Setup leader for Ack
nnoremap <leader>a :Ag<space>

" Setup leader for Commant-T
nmap <leader>f :CommandTFlush<cr>\|:CommandT<cr>

set wildignore=node_modules/**

" Fix esc and cursor key navigation in command-t
set ttimeoutlen=50
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif


" --------------------------------------------------------
" little helper to clean up whitespace
" --------------------------------------------------------
function! CleanupWhitespace()
  exec ":silent %s/\\t/  /ge"
  exec ":silent %s/\\s\\+$//ge"
  " Note -- run the tabs sub first, so blank lines can be cleaned after
endfunction

nnoremap <leader><tab> :call CleanupWhitespace()<cr>

" --------------------------------------------------------
" Ruby test runner
" --------------------------------------------------------

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<exhibits\>') != -1 || match(current_file, '\<services\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>et :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>

function! RunTestFile()
  let filename = expand("%")

  if match(filename, '\.feature$') != -1
    exec ":!cucumber " . filename
  elseif match(filename, '_spec\.js$') != -1
    exec ":!make test"
  elseif match(filename, '_spec\.rb$') != -1
    exec ":!rspec " . filename
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BLOCK EDITING HELPERS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Inc(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction

function! Incr()
  let g:i = 1
  exec ":'<,'>s/@i/\\=Inc()/e"
endfunction
vnoremap <C-a> :call Incr()<CR>
