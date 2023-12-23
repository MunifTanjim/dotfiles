local u = require("plugins.lsp.utils")

local mason_lsp = require("mason-lspconfig")
mason_lsp.setup({
  ensure_installed = {
    "bashls",
    "cssls",
    "emmet_ls",
    "gopls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "tsserver",
    "vimls",
    "yamlls",
  },
})

local server_config = {
  emmet_ls = {
    filetypes = { "html", "css", "scss" },
  },
  lua_ls = u.lua_ls.server_config,
  jsonls = {
    settings = {
      json = {
        schemas = vim.list_extend({
          {
            fileMatch = { ".luarc.json", ".luarc.jsonc" },
            name = "LuaLS Settings",
            url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
          },
        }, require("schemastore").json.schemas()),
        validate = { enable = true },
      },
    },
  },
  tsserver = function(_, config)
    local inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      ---@type 'none'|'literals'|'all'
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
    }

    config.settings = {
      typescript = {
        inlayHints = inlayHints,
      },
      javascript = {
        inlayHints = inlayHints,
      },
    }

    local on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      vim.api.nvim_buf_create_user_command(bufnr, "OI", function(opts)
        require("typescript").actions.organizeImports({ sync = opts.bang })
      end, { desc = "Organize Imports", bang = true })
    end
  end,
  rust_analyzer = function(_, config)
    local on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      require("config.utils").set_keymaps("n", {
        {
          "<M-K>",
          ":RustMoveItemUp<CR>",
          "[lsp:rust] move up",
        },
        {
          "<M-J>",
          ":RustMoveItemDown<CR>",
          "[lsp:rust] move down",
        },
      })
    end

    config.settings = {
      ["rust-analyzer"] = {},
    }
  end,
}

local server_setup = {
  tsserver = function(_, config)
    require("typescript").setup({ server = config })
  end,
  rust_analyzer = function(_, config)
    require("rust-tools").setup({
      server = config,
      tools = {
        inlay_hints = {
          auto = false,
        },
      },
    })
  end,
  ["*"] = function(server, config)
    server.setup(config)
  end,
}

local function default_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  u.setup_keymaps(client, bufnr)
  u.setup_format_on_save(client, bufnr)
  u.setup_document_highlight(client, bufnr)
  u.setup_inlay_hints(client, bufnr)
end

local function make_config(server, config)
  local default_config = {
    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    ),
    on_attach = default_on_attach,
  }

  if type(config) == "function" then
    return config(server, default_config) or default_config
  end

  return vim.tbl_deep_extend("force", default_config, config or {})
end

for _, server_name in ipairs(mason_lsp.get_installed_servers()) do
  local server = require("lspconfig")[server_name]
  local config = make_config(server, server_config[server.name])
  local setup = server_setup[server.name] or server_setup["*"]
  setup(server, config)
end

vim.api.nvim_create_user_command("Format", function(params)
  local format = require("plugins.lsp.custom").format
  if params.range > 0 then
    format({ range = vim.lsp.util.make_given_range_params() })
  else
    format()
  end
end, { desc = "[lsp] format content", range = "%" })

local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
  })

  vim.schedule(function()
    for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
      local hl_def = vim.api.nvim_get_hl_by_name("Diagnostic" .. severity, true)
      vim.api.nvim_set_hl(0, "DiagnosticLineNr" .. severity, { fg = hl_def.foreground, bold = true })
      vim.fn.sign_define("DiagnosticSign" .. severity, { numhl = "DiagnosticLineNr" .. severity })
    end
  end)
end

setup_diagnostics()
