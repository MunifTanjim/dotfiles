-- exrc.nvim

require("config.exrc")

-- nvim-spectre

vim.api.nvim_exec(
  [[
  nnoremap <Leader>S :lua require('spectre').open()<CR>
  ]],
  false
)

-- treesitter

require("config.treesitter")
