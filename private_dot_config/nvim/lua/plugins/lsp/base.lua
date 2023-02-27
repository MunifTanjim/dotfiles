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
    local luarc = u.lua_ls.read_luarc()

    local function get_workspace_library()
      local workspace_library = {}

      if luarc.workspace then
        if luarc.workspace.library then
          ---@diagnostic disable-next-line: missing-parameter
          vim.list_extend(
            workspace_library,
            vim.tbl_map(function(lib)
              return vim.fn.expand(lib)
            end, luarc.workspace.library)
          )
        end
      end

      if luarc.nvim then
        table.insert(workspace_library, u.lua_ls.get_nvim_lib_dir("lua-dev.nvim") .. "/types")
        vim.list_extend(workspace_library, u.lua_ls.get_nvim_lib_dirs(luarc.nvim.packages))
      end

      if not luarc.workspace and not luarc.nvim then
        table.insert(workspace_library, u.lua_ls.get_nvim_lib_dir("lua-dev.nvim") .. "/types")
        vim.list_extend(workspace_library, u.lua_ls.get_nvim_lib_dirs())
      end

      return workspace_library
    end

    config.settings = {
      Lua = {
        format = {
          enable = false,
        },
        runtime = vim.tbl_deep_extend("force", {
          version = "LuaJIT",
          path = { "?.lua", "?/init.lua", "lua/?.lua", "lua/?/init.lua" },
        }, luarc.runtime or {}),
        workspace = {
          checkThirdParty = false,
          library = get_workspace_library(),
          maxPreload = 10000,
          preloadFileSize = 10000,
        },
        telemetry = {
          enable = false,
        },
      },
    }
  end

  if server.name == "jsonls" then
    config.settings = {
      json = {
        schemas = vim.list_extend({
          {
            description = "Setting of sumneko.lua",
            fileMatch = { ".luarc.json" },
            name = ".luarc.json",
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
