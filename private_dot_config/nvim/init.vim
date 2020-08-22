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

set nostartofline
set splitbelow
set splitright
set lazyredraw
set updatetime=1000

set clipboard=unnamed

let &backupdir = data_dir . '/backup//,.'
let &directory = data_dir . '/swap//,.'
if has('persistent_undo')
  let &undodir = data_dir . '/undo//,.'
  set undofile
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
" Plug 'morhetz/gruvbox'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'

" functionality
if isdirectory(fzf_root)
  Plug fzf_root
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'
endif
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vitalk/vim-shebang'

" integration
Plug 'tpope/vim-fugitive'
Plug 'wakatime/vim-wakatime'

" language support
Plug 'digitaltoad/vim-pug'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go'] }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'lifepillar/pgsql.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'neoclide/jsonc.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'zinit-zsh/zinit-vim-syntax'

" dark magic
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

call plug#end()

"# Plugin Settings

"## Plugin: vim-fugitive

" keymaps: fugitive
nmap <Leader>gs :G<CR>

"## Plugin: fzf

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

let g:fzf_command_prefix = 'Z'

" fzf in popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'BoxChar' } }

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

" keymaps: fzf
nmap <C-p>     :ZFiles<CR>
nmap <Leader>/ :ZLines<CR>
nmap <Leader>? :ZRG<CR>
nmap <Leader>b :ZBuffers<CR>
nmap <Leader>w :ZWindows<CR>

" keymaps: fzf-checkout
nmap <Leader>gc :ZGCheckout<CR>

"## Plugin: coc

let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-explorer',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

"### coc: commands

" command: Fold
command! -nargs=? Fold     :call CocAction('fold', <f-args>)
" command: Format
command! -nargs=0 Format   :call CocAction('format')
" command: OI
command! -nargs=0 OI       :call CocAction('runCommand', 'editor.action.organizeImport')
" command: Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"### coc: functions

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"### coc: keymaps
"" trigger autocomplete popup menu
inoremap <silent><expr> <C-Space> coc#refresh()
"" highlight next popup menu item
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"" highlight prev popup menu item
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"" select popup-menu item
if exists('*complete_info')
  inoremap <silent><expr> <CR> complete_info()["selected"] != "-1" ? coc#_select_confirm() : "\<C-g>u\<CR>"
else
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
endif
"" map function text object
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
"" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" diagnostics navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"" apply code action to current line
nmap <Leader>ac <Plug>(coc-codeaction-line)
"" apply autofix to problem on the current line
nmap <Leader>qf  <Plug>(coc-fix-current)
"" show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
"" rename symbol
nmap <Leader>rn <Plug>(coc-rename)
"" format code
xmap <Leader>f <Plug>(coc-format-selected)
nmap <Leader>f <Plug>(coc-format-selected)
"" open explorer
nmap <silent> <Space>e :CocCommand explorer<CR>
"" list diagnostics
nnoremap <silent> <Leader>ld  :<C-u>CocList diagnostics<cr>
"" list extensions
nnoremap <silent> <Leader>le  :<C-u>CocList extensions<cr>
"" list commands
nnoremap <silent> <Leader>lc  :<C-u>CocList commands<cr>
"" list outline - symbols from current buffer
nnoremap <silent> <Leader>lo  :<C-u>CocList outline<cr>
"" list symbols - from workspace
nnoremap <silent> <Leader>ls  :<C-u>CocList -I symbols<cr>
"" list: do default action for next item in last list
nnoremap <silent> <Leader>lj  :<C-u>CocNext<CR>
"" list: do default action for prev item in last list
nnoremap <silent> <Leader>lk  :<C-u>CocPrev<CR>
"" list: reopen last list
nnoremap <silent> <Leader>lp  :<C-u>CocListResume<CR>

"### coc: autocommands

augroup js_ts_coc
  autocmd!
  " keymap: go to file
  autocmd FileType javascript,typescript nmap <silent> gf <Plug>(coc-definition)
augroup END

augroup coc_explorer
  autocmd!
  autocmd User CocExplorerOpenPre setl statusline=%#NonText#
augroup END

"## Plugin: vim-easy-align

" keymaps: vim-easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"## Plugin: vim-markdown

let g:markdown_fenced_languages = ['css', 'help', 'html', 'javascript', 'js=javascript', 'json=javascript', 'sh', 'typescript', 'ts=typescript', 'vim']

"# Appearance Settings
set cursorline
set number relativenumber
set nowrap
set scrolloff=3

" always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

syntax enable

" enable truecolor
if has('termguicolors')
  if ! has('nvim')
    " *xterm-true-color*
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

augroup override_highlight
    autocmd!
    autocmd ColorScheme gruvbox highlight link BoxChar GruvboxGray
          \ | highlight link CocExplorerIndentLine BoxChar
augroup END

" theme
set background=dark

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

"" airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
""" disable powerline arrows
let g:airline_left_sep=""
let g:airline_left_alt_sep=""
let g:airline_right_sep=""
let g:airline_right_alt_sep=""

" automatically toggle relative line number
augroup auto_relaivenumber_toggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &l:nu && empty(&bt) | setl rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &l:nu && empty(&bt) | setl nornu | endif
augroup END

" keymaps: gruvbox
if g:colors_name == 'gruvbox'
  nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
  nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
  nnoremap <silent> yoh :call gruvbox#hls_toggle()<CR>
  nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
  nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
  nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
endif

" fold settings
set foldlevelstart=15
set foldminlines=3

autocmd Syntax javascript,json,typescript setlocal foldmethod=syntax

"# FileType Specific Settings

"## FileType: json

autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

"## FileType: tmux

autocmd FileType tmux nnoremap <silent><buffer> K :call tmux#man()<CR>

"## FileType: vim

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
inoremap <Up>    <Nop>
inoremap <Right> <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
nnoremap <Up>    <Nop>
nnoremap <Right> <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
vnoremap <Up>    <Nop>
vnoremap <Right> <Nop>
vnoremap <Down>  <Nop>
vnoremap <Left>  <Nop>

" disable Ctrl-a on screen/tmux
if $TERM =~ 'screen\|tmux'
  nnoremap <C-a>         <Nop>
  nnoremap <Leader><C-a> <C-a>
endif

" save
inoremap <C-s> <C-o>:update<CR>
nnoremap <C-s> :update<CR>

" exit insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" beginning/end of line
nnoremap B ^
nnoremap E $
onoremap B ^
onoremap E $
xnoremap B ^
xnoremap E $

" move lines
inoremap <M-j> <Esc>:move .+1<CR>==gi
inoremap <M-k> <Esc>:move .-2<CR>==gi
nnoremap <M-j> :move .+1<CR>==
nnoremap <M-k> :move .-2<CR>==
vnoremap <M-j> :move '>+1<CR>gv=gv
vnoremap <M-k> :move '<-2<CR>gv=gv

" yank from the cursor position to the end of the line
nnoremap Y y$
" yank/paste with system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P
