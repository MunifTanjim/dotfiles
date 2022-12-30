local u = require("config.utils")

require("treesitter-context").setup({
  max_lines = 3,
  trim_scope = "outer",
  patterns = {
    default = {
      "class",
      "function",
      "method",
      "if",
      "case",
    },
    rust = {
      "impl_item",
      "struct",
      "enum",
      "match_arm",
    },
  },
  exact_patterns = {},
})

u.set_keymap("n", "<Leader>tsc", "<cmd>TSContextToggle<CR>", "[treesitter] toggle context")

vim.schedule(function()
  vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
  vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLine" })
end)
