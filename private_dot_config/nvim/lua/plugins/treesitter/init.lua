local u = require("config.utils")

local plugins = {
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    init = function()
      u.set_keymaps("n", {
        {
          "<Leader>ghg",
          "<Cmd>TSHighlightCapturesUnderCursor<CR>",
          "[treesitter] show hl captures",
        },
        {
          "<Leader>gtr",
          "<Cmd>TSPlaygroundToggle<CR>",
          "[treesitter] toggle playground",
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
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
      require("plugins.treesitter.comment")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}

return plugins
