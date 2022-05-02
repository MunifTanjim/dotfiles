local lsp_server_names = {
  "bashls",
  "cssls",
  "dockerls",
  "gopls",
  "html",
  "jsonls",
  "pyright",
  "sumneko_lua",
  "tsserver",
  "vimls",
  "yamlls",
}

require("nvim-lsp-installer").setup({
  ensure_installed = lsp_server_names,
})

require("config.lsp.custom")
require("config.lsp.null-ls")

vim.diagnostic.config({
  virtual_text = false,
})

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local map_opts = { noremap = true, silent = true }

  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", map_opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", map_opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", map_opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", map_opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", map_opts)
  buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", map_opts)
  -- buf_set_keymap("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", map_opts)
  -- buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", map_opts)
  buf_set_keymap("n", "<Leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", map_opts)
  -- buf_set_keymap("v", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", map_opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", map_opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", map_opts)
  -- buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  buf_set_keymap("n", "<Leader>rn", '<cmd>lua require("config.lsp.custom").rename()<CR>', map_opts)

  buf_set_keymap("n", "<Leader>f", "<cmd>lua require('config.lsp.formatting').format()<CR>", map_opts)
  buf_set_keymap("x", "<Leader>f", "<cmd>lua require('config.lsp.formatting').range_format()<CR>", map_opts)

  -- if client.server_capabilities.document_highlight then
  --   vim.cmd([[
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --   ]])
  -- end

  vim.cmd([[command! Format execute 'lua require('config.lsp.formatting').format()']])
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  return {
    capabilities = capabilities,
    on_attach = on_attach,
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
      },
    }
  end

  if server.name == "tsserver" then
    config.on_attach = function(client, bufnr)
      require("config.lsp.typescript").patch_client(client)

      on_attach(client, bufnr)

      vim.cmd("command! -buffer OI lua require('config.lsp.typescript').organize_imports()")
    end
  end

  server.setup(config)
end

for _, server_name in ipairs(lsp_server_names) do
  setup_server(require("lspconfig")[server_name])
end

local function setup_trouble()
  local trouble = require("trouble")

  trouble.setup({
    action_keys = {
      close = "gq",
    },
  })

  vim.cmd("nnoremap <silent> <Leader>xx :TroubleToggle<CR>")
end

setup_trouble()

vim.cmd("autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()")
