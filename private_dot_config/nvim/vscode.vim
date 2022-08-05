" vim: set foldmethod=marker foldmarker=[[[,]]] foldlevel=0 nomodeline :

set noloadplugins

" [[[ General Settings

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

" General Keymaps ]]]

" [[[ Plugins

" install vim-plug automagically
let plug_path = stdpath('data') . '/site/pack/vscode/opt/plug/autoload/plug.vim'
if empty(glob(plug_path))
  silent execute '!curl -fLo ' . plug_path . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * packadd plug | PlugInstall --sync | execute 'source ' . expand('<sfile>')
else
  packadd plug
endif

call plug#begin(stdpath('data') . '/site/pack/vscode/opt')

Plug 'junegunn/vim-plug'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'

call plug#end()

" [[[ Plugin: vscode-neovim

" remove move editor mappings
nunmap <C-w><C-j>
xunmap <C-w><C-j>
nunmap <C-w><C-i>
xunmap <C-w><C-i>
nunmap <C-w><C-h>
xunmap <C-w><C-h>
nunmap <C-w><C-l>
xunmap <C-w><C-l>

" vim-commentary equivalent
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Plugin: vscode-neovim ]]]

" Plugins ]]]

" [[[ VSCode Keymaps

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

" code navigation
nmap <silent> gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
nmap <silent> gy :call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
nmap <silent> gi :call VSCodeNotify('editor.action.goToImplementation')<CR>
nmap <silent> gr :call VSCodeNotify('editor.action.goToReferences')<CR>

" rename symbol
nmap <Leader>rn :call VSCodeNotify('editor.action.rename')<CR>

" VSCode Keymaps ]]]
