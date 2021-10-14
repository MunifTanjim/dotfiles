-- exrc.nvim

vim.o.exrc = false
require("exrc").setup()

-- nvim-spectre

vim.api.nvim_exec(
  [[
  nnoremap <Leader>S :lua require('spectre').open()<CR>
  ]],
  false
)

-- treesitter

require("config.treesitter")
