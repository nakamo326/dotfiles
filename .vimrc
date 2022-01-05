if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/nakamo/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/nakamo/.cache/dein')
  call dein#begin('/home/nakamo/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/nakamo/.cache/dein/repos/github.com/Shougo/dein.vim')

  let s:toml      = '$HOME/dotfiles/dein.toml'
  let s:lazy_toml = '$HOME/dotfiles/dein_lazy.toml'
  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  "call dein#load_toml(s:toml,      {'lazy': 0})
  "call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('Yggdroot/indentLine')
  call dein#add('tomasr/molokai')
  call dein#add('joshdick/onedark.vim')
  call dein#add('toupeira/vim-desertink')
  call dein#add('morhetz/gruvbox')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('preservim/nerdtree')


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


set termguicolors

set hlsearch
set number
set ignorecase
set incsearch
set smartcase
set autoindent
set shiftwidth=4
set wildmenu
set ruler
set tabstop=4
set cursorline
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
nnoremap  <C-j> }
nnoremap  <C-k> {
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
set showmatch
set laststatus=2
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
colorscheme gruvbox
let g:airline_theme='gruvbox'
set background=dark
