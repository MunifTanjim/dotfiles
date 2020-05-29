set softtabstop=2
set shiftwidth=2
set expandtab
set incsearch

set splitbelow
set splitright

set clipboard=unnamed

" use different directories for vim and neovim
let cache_dir = '~/.cache/' . ( has('nvim') ? 'nvim' : 'vim' )
let config_dir = has('nvim') ? '~/.config/nvim' : '~/.vim'
let data_dir = '~/.local/share/' . ( has('nvim') ? 'nvim' : 'vim' )

" install vim-plug automagically
if empty(glob(config_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . config_dir . '/autoload/plug.vim' . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugged')

Plug 'junegunn/vim-plug'

" appearance
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" functionality
Plug 'tpope/vim-surround'

" integration
Plug 'tpope/vim-fugitive'

" dark magic
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" enable truecolor
if (has("termguicolors"))
  set termguicolors
endif

" appearance
syntax on
set number relativenumber
colorscheme onedark
let g:onedark_terminal_italics=1
let g:airline_theme='onedark'

" start: coc

let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

" trigger autocomplete popup menu
inoremap <silent><expr> <c-space> coc#refresh()
" highlight next popup menu item
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" highlight prev popup menu item
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" select highlighted popup menu item
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

"   end: coc

let mapleader = "<space>"
let maplocalleader = "\\"

" exit insert mode
inoremap jk <Esc>
inoremap kj <Esc>
inoremap <Esc> <Nop>

" disable arrow keys
inoremap <Up> <Nop>
inoremap <Right> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
nnoremap <Up> <Nop>
nnoremap <Right> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
vnoremap <Up> <Nop>
vnoremap <Right> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
