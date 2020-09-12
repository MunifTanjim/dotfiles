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

" move lines
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

"# VSCode Keymaps

noremap <Leader>e :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

nnoremap <silent> <C-w>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-w>j :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-w>k :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-w>k :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-w>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-w>h :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-w>l :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-w>l :call VSCodeNotify('workbench.action.navigateRight')<CR>
