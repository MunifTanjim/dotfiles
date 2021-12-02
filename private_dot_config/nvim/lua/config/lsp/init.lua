local lsp_config = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")

local exrc = require("config.exrc")

require("config.lsp.custom")

vim.diagnostic.config({
  virtual_text = false,
})

local function remove_formatting_capabilities(client)
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

local function setup_null_ls()
  local null_ls = require("null-ls")

  null_ls.config({
    sources = {
      null_ls.builtins.formatting.stylua,
    },
  })

  lsp_config["null-ls"].setup({
    on_attach = function(client, bufnr)
      local map_opts = { noremap = true, silent = true }

      if client.resolved_capabilities.document_formatting then
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", map_opts)

        if exrc.lsp.format_on_save then
          vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
        end
      end

      if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_keymap(bufnr, "x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting({})<CR>", map_opts)
      end
    end,
  })

  local eslint = require("eslint")
  eslint.setup({
    bin = "eslint_d",
  })

  local prettier = require("prettier")
  prettier.setup({
    bin = "prettier",
  })
end

setup_null_ls()

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
  -- buf_set_keymap("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", map_opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", map_opts)
  -- buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  buf_set_keymap("n", "<Leader>rn", '<cmd>lua require("config.lsp.custom").rename()<CR>', map_opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", map_opts)
  end

  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting({})<CR>", map_opts)
  end

  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  vim.cmd([[command! Format execute 'lua vim.lsp.buf.formatting()']])
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  return {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

lsp_installer.on_server_ready(function(server)
  local config = make_config()

  if server.name == "emmet_ls" then
    config.filetypes = { "html", "css", "scss" }
  end

  if server.name == "html" then
    config.on_attach = function(client, bufnr)
      local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

      if filetype == "markdown" then
        remove_formatting_capabilities(client)
      end

      on_attach(client, bufnr)
    end
  end

  if server.name == "sumneko_lua" then
    local runtime_path = { "./?.lua", "lua/?.lua", "lua/?/init.lua" }

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
    config.on_attach = function(client, bufnr)
      remove_formatting_capabilities(client)

      on_attach(client, bufnr)
    end

    config.settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    }
  end

  if server.name == "tsserver" then
    config.on_attach = function(client, bufnr)
      require("config.lsp.typescript").patch_client(client)

      remove_formatting_capabilities(client)

      on_attach(client, bufnr)

      vim.cmd("command! -buffer OI lua require('config.lsp.typescript').organize_imports()")
    end
  end

  server:setup(config)
end)

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
