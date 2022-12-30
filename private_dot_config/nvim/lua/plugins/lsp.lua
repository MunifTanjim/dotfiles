local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/lua-dev.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/typescript.nvim",
      "onsails/lspkind-nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          config = {
            ui = { border = "rounded" },
          },
        },
      },
    },
    config = function()
      require("plugins.lsp.base")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "MunifTanjim/eslint.nvim",
      "MunifTanjim/prettier.nvim",
    },
    config = function()
      require("plugins.lsp.null-ls")
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("plugins.lsp.lightbulb")
    end,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("plugins.lsp.trouble")
    end,
  },
}

return plugins
