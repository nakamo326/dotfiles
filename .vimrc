" プラグインなしの最小構成
syntax enable
filetype plugin indent on
set background=dark
silent! colorscheme habamax
if has('termguicolors')
  set termguicolors
endif

" 表示
set number
set ruler
set cursorline
set showmatch
set laststatus=2
set wildmenu
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" 検索
set hlsearch
set incsearch
set ignorecase
set smartcase

" インデント・編集
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set backspace=start,eol,indent

" 移動
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
nnoremap <C-j> }
nnoremap <C-k> {
