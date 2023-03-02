local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/typescript.nvim",
      "onsails/lspkind-nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          cmd = "Mason",
          opts = {
            ui = { border = "rounded" },
          },
        },
      },
    },
    event = "BufReadPre",
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
    event = "BufReadPre",
    config = function()
      require("plugins.lsp.null-ls")
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    config = function()
      require("plugins.lsp.lightbulb")
    end,
  },
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    config = function()
      require("plugins.lsp.trouble")
    end,
  },
}

return plugins
