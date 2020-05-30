" use different directories for vim and neovim
let cache_dir = '~/.cache/' . ( has('nvim') ? 'nvim' : 'vim' )
let config_dir = has('nvim') ? '~/.config/nvim' : '~/.vim'
let data_dir = '~/.local/share/' . ( has('nvim') ? 'nvim' : 'vim' )

" other directories
let fzf_root = fnamemodify(data_dir, ':h') . '/fzf'

"# Plugins

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
if isdirectory(expand(fzf_root))
  Plug fzf_root
  Plug 'junegunn/fzf.vim'
endif
Plug 'tpope/vim-surround'

" integration
Plug 'tpope/vim-fugitive'

" dark magic
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"# Plugin Settings

"## Plugin: fzf

" hide statusline while fzf-ing
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

let g:fzf_command_prefix = 'Z'

"## Plugin: COC
let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-prettier',
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

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"# General Settings
set softtabstop=2
set shiftwidth=2
set expandtab
set incsearch

set splitbelow
set splitright

set clipboard=unnamed

"## Appearance Settings
syntax on
set number relativenumber

" enable truecolor
if has('termguicolors')
  if ! has('nvim')
    " *xterm-true-color*
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

" theme
colorscheme onedark
let g:onedark_terminal_italics=1
let g:airline_theme='onedark'

"# Language Specific Settings

"## Language: JSON
autocmd FileType json syntax match Comment +\/\/.\+$+

"## Language: VIM
autocmd FileType vim set foldexpr=VimFolds(v:lnum)
function! VimFolds(lnum)
  let s:cur_line = getline(a:lnum)
  if s:cur_line =~ '^"#'
    return '>' . (matchend(s:cur_line, '"#*') - 1)
  else
    return '='
  endif
endfunction

"# Key Bindings

let mapleader = "<space>"
let maplocalleader = "\\"

" exit insert mode
inoremap jk <Esc>
inoremap kj <Esc>
inoremap <Esc> <Nop>

" move to beginning/end of line
nnoremap B ^
nnoremap E $

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

" vim:foldmethod=expr:foldlevel=0
