" vim: set foldmethod=expr foldlevel=0 nomodeline :

" use different directories for vim and neovim
let cache_dir  = expand('~/.cache/' . ( has('nvim') ? 'nvim' : 'vim' ))
let config_dir = expand(has('nvim') ? '~/.config/nvim' : '~/.vim')
let data_dir   = expand('~/.local/share/' . ( has('nvim') ? 'nvim' : 'vim' ))

"# General Settings

let &backupdir = data_dir . '/backup//,.'
let &directory = data_dir . '/swap//,.'
if has('persistent_undo')
  let &undodir = data_dir . '/undo//,.'
  set undofile
endif

" <Leader> and <LocalLeader>
let mapleader = "\<Space>"
let maplocalleader = "\\"

"# General Keymaps

" beginning/end of line
nnoremap B ^
nnoremap E $
onoremap B ^
onoremap E $
xnoremap B ^
xnoremap E $

" save
nnoremap <Leader>s :call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <Leader>js :call VSCodeNotify('workbench.action.files.saveWithoutFormatting')<CR>

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

"# Plugins

" install vim-plug automagically
if empty(glob(config_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . config_dir . '/autoload/plug.vim' . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/vscode/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'

call plug#end()

"# vscode-neovim

"## remove move editor mappings
nunmap <C-w><C-j>
xunmap <C-w><C-j>
nunmap <C-w><C-i>
xunmap <C-w><C-i>
nunmap <C-w><C-h>
xunmap <C-w><C-h>
nunmap <C-w><C-l>
xunmap <C-w><C-l>

"## vim-commentary equivalent
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"# VSCode Keymaps

noremap <Leader>e :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

" window navigation
nnoremap <silent> <C-w>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-w>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-w>k :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-w>k :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-w>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-w>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-w>l :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-w>l :call VSCodeNotify('workbench.action.navigateRight')<CR>

" window split
nnoremap <C-w>- :New<CR>
xnoremap <C-w>- :New<CR>
nnoremap <C-w>\ :Vnew<CR>
xnoremap <C-w>\ :Vnew<CR>

"" code navigation
nmap <silent> gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
nmap <silent> gy :call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
nmap <silent> gi :call VSCodeNotify('editor.action.goToImplementation')<CR>
nmap <silent> gr :call VSCodeNotify('editor.action.goToReferences')<CR>
"" rename symbol
nmap <Leader>rn :call VSCodeNotify('editor.action.rename')<CR>
