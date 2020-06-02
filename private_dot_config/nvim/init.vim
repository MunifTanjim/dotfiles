" vim: set foldmethod=expr foldlevel=0 nomodeline :

" use different directories for vim and neovim
let cache_dir  = expand('~/.cache/' . ( has('nvim') ? 'nvim' : 'vim' ))
let config_dir = expand(has('nvim') ? '~/.config/nvim' : '~/.vim')
let data_dir   = expand('~/.local/share/' . ( has('nvim') ? 'nvim' : 'vim' ))

" other directories
let fzf_root = fnamemodify(data_dir, ':h') . '/fzf'

"# General Settings
set hidden
set modelines=2

set encoding=utf-8
set softtabstop=2
set shiftwidth=2
set expandtab

set incsearch
set ignorecase
set smartcase
set wildmenu

set lazyredraw
set splitbelow
set splitright
set scrolloff=5
set nostartofline

set clipboard=unnamed

let &backupdir = data_dir . '/backup//'
let &directory = data_dir . '/swap//'
if has('persistent_undo')
  let &undodir = data_dir . '/undo//'
  set undofile
endif

" always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " fecently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" <Leader> and <LocalLeader>
let mapleader = "\<Space>"
let maplocalleader = "\\"

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
Plug 'vitalk/vim-shebang'
Plug 'junegunn/vim-peekaboo'
if isdirectory(fzf_root)
  Plug fzf_root
  Plug 'junegunn/fzf.vim'
endif
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'

" integration
Plug 'tpope/vim-fugitive'
Plug 'wakatime/vim-wakatime'

" language support
Plug 'digitaltoad/vim-pug'
Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'lifepillar/pgsql.vim'
Plug 'pangloss/vim-javascript'
Plug 'zinit-zsh/zinit-vim-syntax'

" dark magic
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"# Plugin Settings

"## Plugin: FZF

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

let g:fzf_command_prefix = 'Z'

" fzf in popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" hide statusline while fzf-ing
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 nonumber norelativenumber noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 number relativenumber showmode ruler
endif

" better ripgrep command: ZRG
command! -nargs=* -bang ZRG call RipgrepFzf(<q-args>, <bang>0)
function! RipgrepFzf(query, fullscreen)
  let command_fmt = '[ -n %s ] && rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query), shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}', '{q}')
  let spec = {'options': ['--phony', '--prompt', 'Search > ', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" keymaps: FZF
nmap <C-p>     :ZFiles<CR>
nmap <Leader>/ :ZLines<CR>
nmap <Leader>? :ZRG<CR>
nmap <Leader>b :ZBuffers<CR>
nmap <Leader>w :ZWindows<CR>

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

" command: Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" command: OI
command! -nargs=0 OI       :call CocAction('runCommand', 'editor.action.organizeImport')

" functions
function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" keymaps: COC
"" trigger autocomplete popup menu
inoremap <silent><expr> <C-Space> coc#refresh()
"" highlight next popup menu item
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"" highlight prev popup menu item
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"" select highlighted popup menu item
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
"" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
"" rename symbol
nmap <Leader>rn <Plug>(coc-rename)
"" format code
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

augroup js_ts_coc
  autocmd!
  " keymap: go to file
  autocmd FileType javascript,typescript nmap <silent> gf <Plug>(coc-definition)
augroup END

"## Plugin: vim-easy-align

" keymaps: vim-easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"# Appearance Settings
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

"" airline
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
""" disable powerline arrows
let g:airline_left_sep=""
let g:airline_left_alt_sep=""
let g:airline_right_sep=""
let g:airline_right_alt_sep=""

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

"# Keymaps

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

" disable Ctrl-a on screen/tmux
if $TERM =~ 'screen\|tmux'
  nnoremap <C-a>         <Nop>
  nnoremap <Leader><C-a> <C-a>
endif

" quit
inoremap <C-q>     <Esc>:q<CR>
nnoremap <C-q>     :q<CR>
nnoremap <Leader>q :q<CR>
vnoremap <C-q>     <Esc>

" save
inoremap <C-s> <C-o>:update<cr>
nnoremap <C-s> :update<cr>

" exit insert mode
inoremap jk    <Esc>
inoremap kj    <Esc>
inoremap <Esc> <Nop>

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" move line
nnoremap <silent> <M-k> :move-2<cr>
nnoremap <silent> <M-j> :move+<cr>
nnoremap <silent> <M-h> <<
nnoremap <silent> <M-l> >>

" switch buffer
nmap <Leader><Tab> :call feedkeys(":b \<Tab>", 'tn')<CR>
