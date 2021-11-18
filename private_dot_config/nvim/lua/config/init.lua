-- exrc.nvim

require("config.exrc")

-- completion

require("config.completion")

-- nvim-spectre

vim.api.nvim_exec(
  [[
  nnoremap <Leader>S :lua require('spectre').open()<CR>
  ]],
  false
)

-- lsp

require("config.lsp")

-- snippet

require("config.snippet")

-- stabilize

require("stabilize").setup({
  force = false,
})

-- telescope

require("config.telescope")

-- tree

require("config.tree")

-- treesitter

require("config.treesitter")
