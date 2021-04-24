local lsp_config = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")

local exrc = require("config.exrc")

require("config.lsp.custom")

local function setup_null_ls()
  local null_ls = require("null-ls")

  null_ls.config({
    sources = {
      null_ls.builtins.formatting.stylua,
    },
  })

  lsp_config["null-ls"].setup({
    on_attach = function(client, _bufnr)
      if client.resolved_capabilities.document_formatting then
        vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")
        if exrc.lsp.format_on_save then
          -- format on save
          vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
        end
      end

      if client.resolved_capabilities.document_range_formatting then
        vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
      end
    end,
  })

  local eslint = require("eslint")
  eslint.setup({
    bin = "eslint",
  })

  local prettier = require("prettier")
  prettier.setup({
    bin = "prettier",
  })
end

setup_null_ls()

local function on_attach(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local opts = {
    noremap = true,
    silent = true,
  }

  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<Leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  -- buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  buf_set_keymap("n", "<Leader>rn", '<cmd>lua require("config.lsp.custom").rename()<CR>', opts)

  -- vim.api.nvim_exec(
  --   [[
  --   nnoremap <silent> <leader>ac :Lspsaga code_action<CR>
  --   vnoremap <silent> <leader>ac :<C-U>Lspsaga range_code_action<CR>
  --   nnoremap <silent> K :Lspsaga hover_doc<CR>
  --   nnoremap <silent> <C-k> :Lspsaga signature_help<CR>
  --   nnoremap <silent> <Leader>rn :Lspsaga rename<CR>
  --   nnoremap <silent> [d :Lspsaga diagnostic_jump_prev<CR>
  --   nnoremap <silent> ]d :Lspsaga diagnostic_jump_next<CR>
  --   ]]
  --   , false
  -- )

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end
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

  if server.name == "html" then
    config.on_attach = function(client, bufnr)
      local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

      if filetype == "markdown" then
        -- disable formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
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
      -- disable formatting
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      on_attach(client, bufnr)
    end
  end

  if server.name == "tsserver" then
    config.on_attach = function(client, bufnr)
      -- disable tsserver formatting
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      on_attach(client, bufnr)

      vim.cmd("command! -buffer OI lua require'nvim-lsp-ts-utils'.organize_imports()")

      require("config.lsp.typescript").patch_client(client)
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

  vim.api.nvim_exec(
    [[
    nnoremap <silent> <Leader>xx :TroubleToggle<CR>
    ]],
    false
  )
end

setup_trouble()

-- local lsp_saga = require('lspsaga')
--
-- lsp_saga.init_lsp_saga({
--   code_action_keys = {
--     quit = { '<Esc>', 'q' },
--   },
--   finder_action_keys = {
--     quit = { '<Esc>', 'q' },
--   },
--   rename_action_keys = {
--     quit = { '<Esc>' },
--   },
-- })

vim.api.nvim_exec(
  [[
  autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()
  ]],
  false
)
