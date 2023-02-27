" vim: set foldmethod=marker foldmarker=[[[,]]] foldlevel=0 nomodeline :

" [[[ General Settings

set exrc
set hidden
set modeline
set modelines=2
set nomodelineexpr
set secure

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
if exists('&splitkeep')
  set splitkeep=screen
endif

set updatetime=1000

set clipboard=unnamed

set mouse=a

set undofile

" <Leader> and <LocalLeader>
let mapleader = "\<Space>"
let maplocalleader = "\\"

" General Settings ]]]

" [[[ General Keymaps

" beginning/end of line
nnoremap B ^
nnoremap E $
onoremap B ^
onoremap E $
xnoremap B ^
xnoremap E $

" disable Ctrl-a on screen/tmux
if $TERM =~ 'screen\|tmux'
  nnoremap <C-a>         <Nop>
  nnoremap <Leader><C-a> <C-a>
endif

" save
nnoremap <Leader>s :update<CR>
nnoremap <Leader>js :noautocmd update<CR>

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
" paste in visual mode keeping the yank
xnoremap _p "_dP

" make new split
nnoremap <C-w>- :rightbelow new<CR>
nnoremap <C-w>_ :botright new<CR>
nnoremap <C-w>\ :rightbelow vnew<CR>
nnoremap <C-w>\| :botright vnew<CR>

" centered search navigation (`zv` mimics `foldopen=search`)
nnoremap n nzzzv
nnoremap N Nzzzv

" centered scroll
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" General Keymaps ]]]

" [[[ FileType Specific Settings

"" [[[ FileType: help

augroup help_custom_setting
  autocmd!
  autocmd FileType help nnoremap <buffer> gq :quit<CR>
  autocmd FileType help nnoremap <silent><buffer> K :execute 'h ' . expand('<cword>')<CR>
augroup END

"" FileType: help ]]]

"" [[[ FileType: json

autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
autocmd FileType jsonc syntax match Comment +\/\/.\+$+

"" FileType: json ]]]

"" [[[ FileType: tmux

autocmd FileType tmux nnoremap <silent><buffer> K :call tmux#man()<CR>

"" FileType: tmux ]]]

"" [[[ FileType: vim

autocmd FileType vim nnoremap <silent><buffer> K :execute 'h ' . expand('<cword>')<CR>

"" FileType: vim ]]]

" FileType Specific Settings ]]]

" [[[ Plugin Initialization

"" [[[ Plugin: fzf

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_command_prefix = 'Z'

if has('nvim') || has('popupwin')
  " fzf in popup window
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'BoxChar' } }
endif

"" Plugin: fzf ]]]

"" [[[ Plugin: git-messenger

let g:git_messenger_no_default_mappings = v:true
let g:git_messenger_always_into_popup = v:true

"" Plugin: git-messenger ]]]

"" [[[ Plugin: hexokinase

let g:Hexokinase_highlighters = ['foreground']

"" Plugin: hexokinase ]]]

"" [[[ Plugin: matchup

" disable built-in matchit.vim
let g:loaded_matchit = 1

let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_mouse_enabled = 0
let g:matchup_text_obj_enabled = 0

""Plugin: matchup ]]]

"" [[[ Plugin: maximizer

let g:maximizer_default_mapping_key = '<M-m>'

"" Plugin: maximizer ]]]

"" [[[ Plugin: tmux-navigator

let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1

"" Plugin: tmux-navigator ]]]

"" [[[ Plugin: tmux-resizer

let g:tmux_resizer_no_mappings = 1
let g:tmux_resizer_resize_count = 5
let g:tmux_resizer_vertical_resize_count = 10

"" Plugin: tmux-resizer ]]]

" Plugin Initialization ]]]

if has('nvim')
  lua require('config')
else
  let vim_specific_config_file = fnamemodify(expand('<sfile>'), ':h')  . '/vim.vim'
  if filereadable(vim_specific_config_file)
    execute "source " . vim_specific_config_file
  endif
endif

" [[[ Plugin Settings

"" [[[ Plugin: camelcasemotion

map    <silent> <M-w>     <Plug>CamelCaseMotion_w
map    <silent> <M-b>     <Plug>CamelCaseMotion_b
map    <silent> <M-e>     <Plug>CamelCaseMotion_e
map    <silent> g<M-e>    <Plug>CamelCaseMotion_ge
sunmap <M-w>
sunmap <M-b>
sunmap <M-e>
sunmap g<M-e>
imap   <silent> <S-Left>  <C-o><Plug>CamelCaseMotion_b
imap   <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w

"" Plugin: camelcasemotion ]]]

"" [[[ Plugin: carbon-now-sh

let g:carbon_now_sh_options = {
      \ 'bg': '#8f3f71',
      \ 'ln': 'true',
      \ 'fm': 'JetBrains Mono',
      \ 'wc': 'false',
      \ 't': 'monokai' }

"" Plugin: carbon-now-sh ]]]

"" [[[ Plugin: copilot

let g:copilot_no_maps = v:true

"" Plugin: copilot ]]]

"" [[[ Plugin: fzf

" hide statusline while fzf-ing
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 nonumber noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 number showmode ruler
endif

" better ripgrep command: ZRG
command! -nargs=* -bang ZRG call RipgrepFzf(<q-args>, <bang>0)
function! RipgrepFzf(query, fullscreen)
  let command_fmt = '[ -n %s ] && rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query), shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}', '{q}')
  let spec = {'options': ['--disabled', '--prompt', 'Search > ', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

" keymaps: fzf
nmap <C-p>     :ZFiles<CR>
nmap <Leader>/ :ZLines<CR>
nmap <Leader>? :ZRG<CR>
nmap <Leader>b :ZBuffers<CR>
nmap <Leader>w :ZWindows<CR>

" keymaps: fzf-checkout
nmap <Leader>gc :ZGCheckout<CR>

"" Plugin: fzf ]]]

"" [[[ Plugin: easy-align

" keymaps: easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"" Plugin: easy-align ]]]

"" [[[ Plugin: fugitive

" keymaps: fugitive
nmap <Leader>gs :G<CR>

"" Plugin: fugitive ]]]

"" [[[ Plugin: git-messenger

" keymaps: git-messenger
nmap <Leader>go <Plug>(git-messenger)

function! s:setup_git_messenger_popup() abort
    nmap <buffer><Esc> <Plug>(git-messenger-close)
endfunction
autocmd FileType gitmessengerpopup call <SID>setup_git_messenger_popup()

"" Plugin: git-messenger ]]]

"" [[[ Plugin: tmux-navigator

nnoremap <silent> <C-w>h     :TmuxNavigateLeft<CR>
nnoremap <silent> <C-w><C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-w>j     :TmuxNavigateDown<CR>
nnoremap <silent> <C-w><C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-w>k     :TmuxNavigateUp<CR>
nnoremap <silent> <C-w><C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-w>l     :TmuxNavigateRight<CR>
nnoremap <silent> <C-w><C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-w>p     :TmuxNavigatePrevious<CR>
nnoremap <silent> <C-w><C-p> :TmuxNavigatePrevious<CR>

"" Plugin: tmux-navigator ]]]

"" [[[ Plugin: tmux-resizer

nnoremap <silent> <C-w><M-h> :TmuxResizeLeft<CR>
nnoremap <silent> <C-w><M-j> :TmuxResizeDown<CR>
nnoremap <silent> <C-w><M-k> :TmuxResizeUp<CR>
nnoremap <silent> <C-w><M-l> :TmuxResizeRight<CR>

"" Plugin: tmux-resizer ]]]

" Plugin Settings ]]]

" [[[ Appearance Settings

set cursorline
set number
set nowrap
set scrolloff=5

" always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
set signcolumn=yes

" fold settings
set foldlevelstart=15
set foldminlines=3

syntax enable

augroup override_highlight
    autocmd!
    autocmd ColorScheme gruvbox highlight link BoxChar GruvboxGray
          \ | highlight link CocExplorerIndentLine BoxChar
augroup END

" theme
set background=dark

let g:gruvbox_inverse=0
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

" Appearance Settings ]]]

" Everything that can happen, happens. It has to end well and it has to end badly. It has to end every way it can.
