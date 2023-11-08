local color = require("config.color")

vim.api.nvim_set_hl(0, "IblIndent", { fg = color.dark.bg1, nocombine = true })
vim.api.nvim_set_hl(0, "IblScope", { fg = color.faded.purple, nocombine = true })

require("ibl").setup({
  scope = {
    enabled = true,
  },
})
