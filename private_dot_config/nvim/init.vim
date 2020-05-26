syntax on

set softtabstop=2
set shiftwidth=2
set expandtab
set nu
set incsearch

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
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'

call plug#end()

colorscheme onedark
let g:airline_theme='onedark'

inoremap jk <Esc>
inoremap kj <Esc>
inoremap <Esc> <Nop>

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
