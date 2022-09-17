require("which-key").setup({
  window = {
    border = "single",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 0, 0, 0, 0 },
  },
})

vim.schedule(function()
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { link = "Normal" })
end)
