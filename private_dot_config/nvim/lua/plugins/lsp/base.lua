local u = require("plugins.lsp.utils")

local mason_lsp = require("mason-lspconfig")
mason_lsp.setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "emmet_ls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "tailwindcss",
    "vimls",
    "vtsls",
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
  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          },
        },
      },
    },
  },
  vtsls = function(_, config)
    -- ref: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
    local inlayHints = {
      enumMemberValues = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      parameterNames = {
        ---@type 'none'|'literals'|'all'
        enabled = "all",
      },
      parameterTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      variableTypes = { enabled = true },
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

      vim.api.nvim_buf_create_user_command(bufnr, "TypescriptOrganizeImports", function()
        require("vtsls").commands.organize_imports(bufnr)
      end, { desc = "Organize Imports" })

      vim.api.nvim_buf_create_user_command(bufnr, "TypescriptRemoveUnusedImports", function()
        require("vtsls").commands.remove_unused_imports(bufnr)
      end, { desc = "Remove Unused Imports" })
    end
  end,
}

local server_setup = {
  vtsls = function(server, config)
    server.setup(config)
  end,
  rust_analyzer = false,
  ["*"] = function(server, config)
    server.setup(config)
  end,
}

local function setup_server(server_name)
  local server = require("lspconfig")[server_name]
  if server_setup[server.name] == false then
    return
  end

  local config = u.make_server_config(server, server_config[server.name])
  local setup = server_setup[server.name] or server_setup["*"]
  setup(server, config)
end

for _, server_name in ipairs(mason_lsp.get_installed_servers()) do
  setup_server(server_name)
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
      local hl_def = vim.api.nvim_get_hl(0, {
        name = "Diagnostic" .. severity,
        link = false,
      })
      vim.api.nvim_set_hl(0, "DiagnosticLineNr" .. severity, { fg = hl_def.fg, bold = true })
      vim.fn.sign_define("DiagnosticSign" .. severity, { numhl = "DiagnosticLineNr" .. severity, text = "" })
    end
  end)
end

setup_diagnostics()
