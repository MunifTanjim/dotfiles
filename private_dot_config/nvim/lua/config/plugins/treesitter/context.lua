require("treesitter-context").setup({
  max_lines = 2,
  trim_scope = "outer",
  patterns = {
    default = {
      "class",
      "function",
      "method",
    },
  },
  exact_patterns = {},
})

vim.keymap.set("n", "<Leader>tsc", "<cmd>TSContextToggle<CR>")

vim.schedule(function()
  vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
  vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLine" })
end)
