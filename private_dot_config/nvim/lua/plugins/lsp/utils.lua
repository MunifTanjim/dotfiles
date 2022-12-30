local u = require("config.utils")
local custom = require("plugins.lsp.custom")

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
  local opts = { buffer = bufnr }

  u.set_keymaps("n", {
    { "gD", vim.lsp.buf.declaration, "[lsp] declaration" },
    { "gd", vim.lsp.buf.definition, "[lsp] definition" },
    {
      "K",
      function()
        custom.hover(client.offset_encoding)
      end,
      "[lsp] hover",
    },
    { "gi", vim.lsp.buf.implementation, "[lsp] implementation" },
    { "<C-k>", vim.lsp.buf.signature_help, "[lsp] signature help", mode = { "n", "i" } },
    { "gy", vim.lsp.buf.type_definition, "[lsp] type definition" },
    { "<Leader>rn", custom.rename, "[lsp] rename" },
    { "gr", vim.lsp.buf.references, "[lsp] references" },
    { "<Leader>ac", vim.lsp.buf.code_action, "[lsp] code action", mode = { "n", "v" } },
    {
      "<Leader>do",
      function()
        vim.diagnostic.open_float({ scope = "line" })
      end,
      "[lsp] show line diagnostic",
    },
    { "[d", vim.diagnostic.goto_prev, "[lsp] prev diagnostic" },
    { "]d", vim.diagnostic.goto_next, "[lsp] next diagnostic" },
    { "<Leader>qf", vim.diagnostic.setloclist, "[lsp] diagnostic to location list" },
  }, opts)
end

---@param client table
---@param bufnr integer
function mod.setup_format_keymap(client, bufnr)
  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  local opts = { buffer = bufnr }

  u.set_keymap("n", "<Leader>f<Leader>", require("plugins.lsp.custom").format, "[lsp] format", opts)

  if client.server_capabilities.documentRangeFormattingProvider then
    u.set_keymap("x", "<Leader>f<Leader>", require("plugins.lsp.custom").format, "[lsp] format", opts)
  end
end

mod.sumneko_lua = require("plugins.lsp.utils.sumneko_lua")

return mod
