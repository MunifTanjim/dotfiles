local custom = require("config.lsp.custom")

local mod = {}

---@param client table
---@param bufnr integer
function mod.setup_document_highlight(client, bufnr)
  if not client.server_capabilities.documentHighlightProvider then
    return
  end

  local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = group,
    callback = function()
      return custom.document_highlight(client.offset_encoding)
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

function mod.setup_format_on_save(client, bufnr, options)
  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  options = options or {}

  local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

  local is_async = options.async
  vim.api.nvim_create_autocmd(is_async and "BufWritePost" or "BufWritePre", {
    buffer = bufnr,
    group = group,
    callback = function()
      custom.format({ bufnr = bufnr, async = is_async })
    end,
    desc = "[lsp] format on save",
  })
end

---@param client table
---@param bufnr integer
function mod.setup_basic_keymap(client, bufnr)
  local map_opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
  vim.keymap.set("n", "K", function()
    custom.hover(client.offset_encoding)
  end, map_opts)
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
  vim.keymap.set("n", "<Leader>rn", custom.rename, map_opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
  vim.keymap.set("n", "<Leader>ac", vim.lsp.buf.code_action, map_opts)
  vim.keymap.set("v", "<Leader>ac", vim.lsp.buf.range_code_action, map_opts)
  vim.keymap.set("n", "<Leader>do", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, map_opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts)
  vim.keymap.set("n", "<Leader>qf", vim.diagnostic.setloclist, map_opts)
end

---@param client table
---@param bufnr integer
function mod.setup_format_keymap(client, bufnr)
  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  local map_opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "<Leader>f", require("config.lsp.custom").format, map_opts)

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("x", "<Leader>f", require("config.lsp.custom").format, map_opts)
  end
end

return mod
