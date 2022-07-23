local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "▎" },
  },
  on_attach = function(bufnr)
    local function set_keymap(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    set_keymap("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end

      vim.schedule(function()
        gitsigns.prev_hunk()
      end)
      return "<ignore>"
    end, { expr = true })

    set_keymap("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end

      vim.schedule(function()
        gitsigns.next_hunk()
      end)

      return "<ignore>"
    end, { expr = true })

    set_keymap("v", "<leader>gs", ":Gitsigns stage_hunk<cr>")
  end,
})

vim.schedule(function()
  vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvboxOrangeSign" })
end)
