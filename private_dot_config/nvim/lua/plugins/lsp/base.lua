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

local function default_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  u.setup_basic_keymap(client, bufnr)
  u.setup_format_keymap(client, bufnr)
  u.setup_format_on_save(client, bufnr)
  u.setup_document_highlight(client, bufnr)
end

local function make_config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  return {
    capabilities = capabilities,
    on_attach = default_on_attach,
  }
end

local function setup_server(server)
  local config = make_config()

  if server.name == "emmet_ls" then
    config.filetypes = { "html", "css", "scss" }
  end

  if server.name == "lua_ls" then
    u.lua_ls.prepare_config(config)
  end

  if server.name == "jsonls" then
    config.settings = {
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
    }
  end

  if server.name == "tsserver" then
    require("typescript").setup({
      server = {
        on_attach = function(client, bufnr)
          default_on_attach(client, bufnr)

          vim.api.nvim_buf_create_user_command(bufnr, "OI", function(opts)
            require("typescript").actions.organizeImports({ sync = opts.bang })
          end, { desc = "Organize Imports", bang = true })
        end,
      },
    })

    return
  end

  server.setup(config)
end

for _, server_name in ipairs(mason_lsp.get_installed_servers()) do
  setup_server(require("lspconfig")[server_name])
end

vim.api.nvim_create_user_command("Format", function(params)
  local format = require("plugins.lsp.custom").format
  if params.range > 0 then
    format({ range = vim.lsp.util.make_given_range_params() })
  else
    format()
  end
end, { desc = "[lsp] format content", range = "%" })

vim.schedule(function()
  -- tweak lsp document_highlight hl_groups
  local hl_def = vim.api.nvim_get_hl_by_name("GruvboxBg1", true)
  vim.api.nvim_set_hl(0, "LspReferenceText", { bg = hl_def.foreground })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "LspReferenceText" })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "LspReferenceText" })
end)

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
