return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = [[<C-\>]],
    shade_terminals = false,
    on_open = function(term)
      local winid, bufnr = term.window, term.bufnr

      vim.wo[winid].signcolumn = "no"

      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", [[<C-\>]], ":ToggleTerm<CR>", opts)
      vim.keymap.set("t", [[<C-\>]], [[<C-\><C-n>]], opts)
      vim.keymap.set("t", [[<C-w>]], [[<C-\><C-n><C-w>]], opts)
    end,
  },
}
