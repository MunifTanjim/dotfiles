local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "nvim-treesitter/playground",
      "windwp/nvim-ts-autotag",
    },
    event = "BufReadPost",
    config = function()
      require("plugins.treesitter.base")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("plugins.treesitter.context")
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("plugins.treesitter.comment")
    end,
  },
}

return plugins
