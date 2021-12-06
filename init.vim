
" ===== dein settings =====
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  let s:toml      = '$HOME/dotfiles/dein.toml'
  let s:lazy_toml = '$HOME/dotfiles/dein_lazy.toml'
  call dein#load_toml(s:toml,      {'lazy': 0})
  "call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

call map(dein#check_clean(), "delete(v:val, 'rf')")
" :call dein#recache_runtimepath()

" ===== end =====


" ui
set termguicolors
set background=dark
set number
set ruler
set cursorline
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set laststatus=2


set autoindent
set shiftwidth=4
set tabstop=4
set cindent
set expandtab

" search
set hlsearch
set ignorecase
set incsearch
set smartcase
set wrapscan

set wildmenu

set showmatch
set matchtime=1

" keymap
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
nnoremap  <C-j> }
nnoremap  <C-k> {

