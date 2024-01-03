local u = require("config.utils")

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
        -- "simrat39/rust-tools.nvim",
        "MunifTanjim/rust-tools.nvim",
        branch = "patched",
      },
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
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.lsp.base")
    end,
  },
  {
    "nvimtools/none-ls.nvim", -- "jose-elias-alvarez/null-ls.nvim"
    dependencies = {
      u.dev_plugin("MunifTanjim/eslint.nvim"),
      u.dev_plugin("MunifTanjim/prettier.nvim"),
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
    keys = {
      {
        "<Leader>xx",
        "<Cmd>TroubleToggle<CR>",
        desc = "toggle trouble",
      },
    },
    opts = {
      action_keys = {
        close = "gq",
      },
    },
  },
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    config = function()
      local crates = require("crates")
      crates.setup({
        on_attach = function(bufnr)
          require("config.utils").set_keymap("n", "K", function()
            if crates.popup_available() then
              crates.show_popup()
            else
              vim.lsp.buf.hover()
            end
          end, "[lsp] hover", { buffer = bufnr })
        end,
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })
    end,
  },
}

return plugins
