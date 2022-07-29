-- exrc.nvim

require("config.exrc")

-- autopairs

require("config.autopairs")

-- comment

require("config.comment")

-- completion

require("config.completion")

-- dap

require("config.dap")

-- gitsigns

require("config.gitsigns")

-- nvim-spectre

vim.cmd("nnoremap <Leader>S :lua require('spectre').open()<CR>")

-- lsp

require("config.lsp")

-- snippet

require("config.snippet")

-- -- stabilize
--
-- require("stabilize").setup({
--   force = false,
-- })

-- telescope

require("config.telescope")

-- tree

require("config.tree")
require("config.neo-tree")

-- treesitter

require("config.treesitter")

-- ui

require("config.ui").override_input()
require("config.ui").override_select()
