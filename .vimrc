" Set colorscheme
set bg=dark

try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  " no-op
endtry

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
set colorcolumn=80,100

" use system clipboard
set clipboard=unnamed

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

" color time! (via JT)
highlight Search ctermbg=0
highlight StatusLine cterm=none
highlight StatusLineNC cterm=none
highlight VertSplit ctermfg=8 ctermbg=8
highlight Visual ctermbg=0
highlight WarningMsg ctermfg=3 cterm=none

" --------------------------------------------------------
" Filetype stuff
" --------------------------------------------------------

autocmd BufNewFile,BufRead *.thor set filetype=ruby
autocmd BufNewFile,BufRead *.tt set filetype=ruby
autocmd BufNewFile,BufRead *.rabl set filetype=ruby
autocmd BufNewFile,BufRead *.sass set filetype=sass
autocmd BufNewFile,BufRead *.hamlc set filetype=haml
autocmd BufNewFile,BufRead *.hamstache set filetype=haml
autocmd BufNewFile,BufRead *.erb set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Ruby files without extensions
autocmd BufNewFile,BufRead Gemfile     setfiletype ruby
autocmd BufNewFile,BufRead Isolate     setfiletype ruby
autocmd BufNewFile,BufRead Vagrantfile setfiletype ruby
autocmd BufNewFile,BufRead config.ru   setfiletype ruby

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

let g:airline_left_sep='' " Hide silly Airline carot
set ttimeoutlen=50 " Fix delay issue with mode display in Airline
let g:github_enterprise_urls = ['https://git.musta.ch'] " GHE support for fugitive

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
" command-t
" --------------------------------------------------------
nmap <leader>rf :CommandTFlush<cr>\|:CommandT<cr>
nmap <leader>f :CommandT<cr>

let g:CommandTMaxFiles=100000

" Fix esc and cursor key navigation in command-t
set ttimeoutlen=50
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

let g:CommandTMatchWindowReverse = 0

" monorail has a ton of files
let g:CommandTWildIgnore="app/assets/images/**,tmp/**,public/**,node_modules/**,vendor/plugins/**"

" use the pwd as root -- don't look for SCM root (allows for proper usage
" in gem paths)
let g:CommandTTraverseSCM = 'pwd'

" use `git ls-files` for scanning. decent performance since 'find' has issues
" w/ monorail
let g:CommandTFileScanner = 'git'

" --------------------------------------------------------
" Ruby helpers
" --------------------------------------------------------
nnoremap <leader>d :!ag "^ +?def" %<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Block editing helpers
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GoLang setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"
autocmd FileType go set tabstop=4|set shiftwidth=4|set expandtab|set nolist
