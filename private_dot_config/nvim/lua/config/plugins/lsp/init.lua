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
    "sumneko_lua",
    "tsserver",
    "vimls",
    "yamlls",
  },
})

---@param client table
---@param bufnr integer
local function setup_document_highlight(client, bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})

  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = group,
    callback = function()
      return require("config.lsp.custom").document_highlight(client.offset_encoding)
    end,
    desc = "[lsp] document highlight",
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    group = group,
    callback = vim.lsp.buf.clear_references,
    desc = "[lsp] clear references",
  })
end

local function default_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local map_opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, map_opts)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, map_opts)
  -- vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, map_opts)
  -- vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, map_opts)
  -- vim.keymap.set("n", "<Leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, map_opts)
  vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, map_opts)
  -- vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, map_opts)
  vim.keymap.set("n", "<Leader>rn", require("config.lsp.custom").rename, map_opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
  vim.keymap.set("n", "<Leader>ac", vim.lsp.buf.code_action, map_opts)
  vim.keymap.set("v", "<Leader>ac", vim.lsp.buf.range_code_action, map_opts)
  vim.keymap.set("n", "<Leader>do", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, map_opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts)
  vim.keymap.set("n", "<Leader>qf", vim.diagnostic.setloclist, map_opts)

  vim.keymap.set("n", "<Leader>f", require("config.lsp.formatting").format, map_opts)
  vim.keymap.set("x", "<Leader>f", require("config.lsp.formatting").range_format, map_opts)

  if client.server_capabilities.documentHighlightProvider then
    setup_document_highlight(client, bufnr)
  end

  vim.api.nvim_create_user_command("Format", function(params)
    if params.range > 0 then
      require("config.lsp.formatting").range_format()
    else
      require("config.lsp.formatting").format()
    end
  end, { desc = "format buffer content", range = "%" })
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

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

  if server.name == "sumneko_lua" then
    local runtime_path = { "?.lua", "?/init.lua", "lua/?.lua", "lua/?/init.lua" }

    local workspace_library = {
      vim.fn.expand("$VIMRUNTIME/lua"),
    }

    for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
      if string.sub(path, -12) == "lua-dev.nvim" then
        table.insert(workspace_library, path .. "/types")
      else
        local lua_path = path .. "/lua"
        if vim.fn.isdirectory(lua_path) == 1 then
          table.insert(workspace_library, lua_path)
        end
      end
    end

    config.settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = workspace_library,
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
        schemas = require("schemastore").json.schemas(),
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
