vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/vsnip"

vim.g.vsnip_filetypes = {
  javascriptreact = { "javascript" },
  typescript = { "javascript" },
  typescriptreact = { "javascript", "typescript", "javascriptreact" },
}

vim.cmd([[
  " Expand
  imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

  " Expand or jump forward
  imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

  " Jump backward
  imap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-h>'
  smap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-h>'

  xmap        <C-j>   <Plug>(vsnip-select-text)
  xmap        <C-l>   <Plug>(vsnip-cut-text)
]])
