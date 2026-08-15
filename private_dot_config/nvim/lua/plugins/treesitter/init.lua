local u = require("config.utils")

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      "williamboman/mason.nvim",
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
          vim.g.no_plugin_maps = true
        end,
        config = function()
          local select_keymaps = {}
          for _, keymap in ipairs({
            { "af", "@function.outer" },
            { "if", "@function.inner" },
            { "ac", "@class.outer" },
            { "ic", "@class.inner" },
          }) do
            local lhs, query = unpack(keymap)
            table.insert(select_keymaps, {
              lhs,
              function()
                require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
              end,
              "[textobject] " .. query,
            })
          end
          u.set_keymaps({ "x", "o" }, select_keymaps)

          require("nvim-treesitter-textobjects").setup({
            select = {
              lookahead = true,
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    config = function()
      require("plugins.treesitter.base")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    config = function()
      require("plugins.treesitter.context")
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}

return plugins
