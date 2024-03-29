local plugin_gitsigns = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function plugin_gitsigns.config()
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

      u.set_keymap("v", "<leader>gs", "<Cmd>Gitsigns stage_hunk<cr>", {
        buffer = bufnr,
        desc = "[git] stage change",
      })
    end,
  })
end

local plugins = {
  plugin_gitsigns,
  { "rhysd/git-messenger.vim" },
  { "tpope/vim-fugitive" },
}

return plugins
