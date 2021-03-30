" vim: set foldmethod=expr foldlevel=0 nomodeline :

"# General Settings

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
nnoremap <Leader>os :call VSCodeNotify('workbench.action.files.saveWithoutFormatting')<CR>

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
