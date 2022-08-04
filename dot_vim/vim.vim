" vim: set foldmethod=marker foldmarker=[[[,]]] foldlevel=0 nomodeline :

let xdg_cache_home = exists('$XDG_CACHE_HOME') ? getenv('XDG_CACHE_HOME') : expand('~/.cache')
let xdg_data_home = exists('$XDG_DATA_HOME') ? getenv('XDG_DATA_HOME') : expand('~/.local/share')
let xdg_state_home = exists('$XDG_STATE_HOME') ? getenv('XDG_STATE_HOME') : expand('~/.local/state')

let config_dir = expand('~/.vim')
let data_dir   = xdg_data_home .. '/vim'
let state_dir  = xdg_state_home . '/vim'

" [[[ General Settings

let &backupdir = state_dir . '/backup//,.'
let &directory = state_dir . '/swap//,.'
if has('persistent_undo')
  let &undodir = state_dir . '/undo//,.'
  set undofile
endif

" General Settings ]]]

" [[[ Plugins

" install vim-plug automagically
let plug_path = config_dir . '/autoload/plug.vim'
if empty(glob(plug_path))
  silent execute '!curl -fLo ' . plug_path . ' --create-dirs '
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
let fzf_root = fnamemodify(data_dir, ':h') . '/fzf'
if isdirectory(fzf_root)
  Plug fzf_root
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'
endif
Plug 'bkad/CamelCaseMotion'
Plug 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'javascriptreact'], 'do': 'make install' }
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-startify'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'szw/vim-maximizer'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" integration
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'rhysd/git-messenger.vim'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'tpope/vim-fugitive'
Plug 'wakatime/vim-wakatime'

" language support
Plug 'bronzehedwick/msmtp-syntax.vim'
Plug 'cespare/vim-toml'
Plug 'chunkhang/vim-mbsync'
Plug 'digitaltoad/vim-pug'
Plug 'ekalinin/Dockerfile.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'jxnblk/vim-mdx-js'
Plug 'lifepillar/pgsql.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'mustache/vim-mustache-handlebars'
Plug 'neoclide/jsonc.vim'
Plug 'neomutt/neomutt.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'vitalk/vim-shebang'

Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'puremourning/vimspector'
Plug 'tpope/vim-commentary'

call plug#end()

" Plugins ]]]

" [[[ Plugin Settings

"" [[[ Plugin: coc

let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-explorer',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-prettier',
      \ 'coc-pyright',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-stylua',
      \ 'coc-sumneko-lua',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

""" [[[ coc: commands
" command: Fold
command! -nargs=? Fold     :call CocAction('fold', <f-args>)
" command: Format
command! -nargs=0 Format   :call CocAction('format')
" command: OI
command! -nargs=0 OI       :call CocActionAsync('runCommand', 'editor.action.organizeImport')
" command: Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
""" coc: commands ]]]

""" [[[ coc: functions
function! s:show_documentation_coc()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
""" coc: functions ]]]

""" [[[ coc: keymaps
"" trigger autocomplete popup menu
inoremap <silent><expr> <C-Space> coc#refresh()
"" highlight next/prev popup menu item
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"" select popup-menu item
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

"" function text object
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
"" class text object
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

"" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" diagnostics navigation
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
"" apply code action to current line
nmap <Leader>ac <Plug>(coc-codeaction-line)
"" apply autofix to problem on the current line
nmap <Leader>qf  <Plug>(coc-fix-current)
"" show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation_coc()<CR>
"" rename symbol
nmap <Leader>rn <Plug>(coc-rename)
"" format code
xmap <Leader>f <Plug>(coc-format-selected)
nmap <Leader>f <Plug>(coc-format-selected)
"" selection range
nmap <silent> <Leader>v <Plug>(coc-range-select)
xmap <silent> <Leader>v <Plug>(coc-range-select)
" "" list diagnostics
" nnoremap <silent> <Leader>ld  :<C-u>CocList diagnostics<cr>
" "" list extensions
" nnoremap <silent> <Leader>le  :<C-u>CocList extensions<cr>
" "" list commands
" nnoremap <silent> <Leader>lc  :<C-u>CocList commands<cr>
" "" list outline - symbols from current buffer
" nnoremap <silent> <Leader>lo  :<C-u>CocList outline<cr>
" "" list symbols - from workspace
" nnoremap <silent> <Leader>ls  :<C-u>CocList -I symbols<cr>
" "" list: do default action for next item in last list
" nnoremap <silent> <Leader>lj  :<C-u>CocNext<CR>
" "" list: do default action for prev item in last list
" nnoremap <silent> <Leader>lk  :<C-u>CocPrev<CR>
" "" list: reopen last list
" nnoremap <silent> <Leader>lp  :<C-u>CocListResume<CR>
"" open explorer
nmap <silent> <Space>e :CocCommand explorer<CR>
""" coc: keymaps ]]]

""" [[[ coc: autocommands
augroup coc_augroup
  autocmd!
  " highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " set formatexpr for specific filetypes
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json,graphql
        \ setlocal formatexpr=CocAction('formatSelected')
  " show signature help after jumping to a placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " keymap: go to file
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact
        \ nmap <silent> gf <Plug>(coc-definition)
augroup END
""" coc: autocommands ]]]

"" Plugin: coc ]]]

"" [[[ Plugin: vimspector

nmap <Leader>dc  <Plug>VimspectorContinue
nmap <Leader>ds  <Plug>VimspectorStop
nmap <Leader>dr  <Plug>VimspectorRestart
nmap <Leader>dp  <Plug>VimspectorPause
nmap <Leader>db  <Plug>VimspectorToggleBreakpoint
nmap <Leader>dcb <Plug>VimspectorToggleConditionalBreakpoint
nmap <Leader>dfb <Plug>VimspectorAddFunctionBreakpoint
nmap <Leader>dcc <Plug>VimspectorRunToCursor
nmap <Leader>dj  <Plug>VimspectorStepOver
nmap <Leader>dl  <Plug>VimspectorStepInto
nmap <Leader>dk  <Plug>VimspectorStepOut
nmap <Leader>dq  :VimspectorReset<CR>

"" Plugin: vimspector ]]]

" Plugin Settings ]]]

" [[[ Appearance

" enable truecolor
if has('termguicolors')
  " *xterm-true-color*
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

" setup cursor shapes
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" fold settings
autocmd Syntax javascript,json,typescript setlocal foldmethod=syntax

" Appearance ]]]
