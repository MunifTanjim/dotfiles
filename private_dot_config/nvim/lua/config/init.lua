-- exrc.nvim

require("config.exrc")

-- autopairs

require("config.autopairs")

-- completion

require("config.completion")

-- nvim-spectre

vim.cmd("nnoremap <Leader>S :lua require('spectre').open()<CR>")

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
