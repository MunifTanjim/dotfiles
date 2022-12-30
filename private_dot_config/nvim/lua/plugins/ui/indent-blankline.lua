local color = require("config.color")

vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = color.dark.bg1, nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = color.faded.purple, nocombine = true })

require("indent_blankline").setup({
  show_current_context = true,
})
