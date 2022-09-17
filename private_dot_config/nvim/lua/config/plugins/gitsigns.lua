local u = require("config.utils")
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
    u.set_keymaps("n", {
      {
        "[c",
        function()
          if vim.wo.diff then
            return "[c"
          end

          vim.schedule(function()
            gitsigns.prev_hunk()
          end)

          return "<ignore>"
        end,
        "[git] prev change",
      },
      {
        "]c",
        function()
          if vim.wo.diff then
            return "]c"
          end

          vim.schedule(function()
            gitsigns.next_hunk()
          end)

          return "<ignore>"
        end,
        "[git] next change",
      },
    }, {
      buffer = bufnr,
      expr = true,
    })

    u.set_keymap("v", "<leader>gs", ":Gitsigns stage_hunk<cr>", {
      buffer = bufnr,
      desc = "[git] stage change",
    })
  end,
})

vim.schedule(function()
  vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvboxOrangeSign" })
end)
