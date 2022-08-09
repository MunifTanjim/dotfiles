require("trouble").setup({
  action_keys = {
    close = "gq",
  },
})

vim.keymap.set("n", "<Leader>xx", ":TroubleToggle<CR>", { silent = true })
