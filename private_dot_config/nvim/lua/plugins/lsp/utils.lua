local u = require("config.utils")
local custom = require("plugins.lsp.custom")

local mod = {}

---@param client { server_capabilities: table<string, boolean|table> }
---@param capability string
local function has_capability(client, capability)
  return not not client.server_capabilities[capability .. "Provider"]
end

---@param dir -1|0|1
---@param severity? "ERROR"|"WARN"|"INFO"|"HINT"
function mod.diagnostic_goto(dir, severity)
  if dir == 0 then
    vim.diagnostic.open_float({ scope = "line" })
    return
  end

  local goto_dir = dir == 1 and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  goto_dir({
    severity = severity and vim.diagnostic.severity[severity] or nil,
  })
end

local augroup = {
  document_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false }),
  format_on_save = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false }),
  inlay_hints = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = false }),
}

---@param client table
---@param bufnr integer
function mod.setup_document_highlight(client, bufnr)
  if not has_capability(client, "documentHighlight") then
    return
  end

  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup.document_highlight })

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = augroup.document_highlight,
    callback = function()
      return custom.document_highlight(client.offset_encoding)
    end,
    desc = "[lsp] document highlight",
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    group = augroup.document_highlight,
    callback = vim.lsp.buf.clear_references,
    desc = "[lsp] clear references",
  })
end

function mod.setup_format_on_save(client, bufnr, options)
  if not has_capability(client, "documentFormatting") then
    return
  end

  options = options or {}

  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup.format_on_save })

  local is_async = options.async
  vim.api.nvim_create_autocmd(is_async and "BufWritePost" or "BufWritePre", {
    buffer = bufnr,
    group = augroup.format_on_save,
    callback = function()
      custom.format({ bufnr = bufnr, async = is_async })
    end,
    desc = "[lsp] format on save",
  })
end

---@param client table
---@param bufnr integer
function mod.setup_keymaps(client, bufnr)
  local opts = { buffer = bufnr }
  local keymaps = {
    { "gD", vim.lsp.buf.declaration, "[lsp] declaration" },
    {
      "K",
      function()
        custom.hover(client.offset_encoding)
      end,
      "[lsp] hover",
    },
    { "gi", vim.lsp.buf.implementation, "[lsp] implementation" },
    { "gy", vim.lsp.buf.type_definition, "[lsp] type definition" },
    { "gr", vim.lsp.buf.references, "[lsp] references" },
    {
      "<Leader>od",
      function()
        mod.diagnostic_goto(0)
      end,
      "[lsp] show line diagnostic",
    },
    {
      "[d",
      function()
        mod.diagnostic_goto(-1)
      end,
      "[lsp] prev diagnostic",
    },
    {
      "]d",
      function()
        mod.diagnostic_goto(1)
      end,
      "[lsp] next diagnostic",
    },
    {
      "[e",
      function()
        mod.diagnostic_goto(-1, "ERROR")
      end,
      "[lsp] prev diagnostic (error)",
    },
    {
      "]e",
      function()
        mod.diagnostic_goto(1, "ERROR")
      end,
      "[lsp] next diagnostic (error)",
    },
    { "<Leader>qf", vim.diagnostic.setloclist, "[lsp] diagnostic to location list" },
  }

  local idx = #keymaps + 1

  if has_capability(client, "definition") then
    keymaps[idx] = { "gd", vim.lsp.buf.definition, "[lsp] definition" }
    idx = idx + 1
  end

  if has_capability(client, "signatureHelp") then
    keymaps[idx] = { "<C-k>", vim.lsp.buf.signature_help, "[lsp] signature help", mode = { "n", "i" } }
    idx = idx + 1
  end

  if has_capability(client, "documentFormatting") then
    keymaps[idx] = { "<Leader>f<Leader>", custom.format, "[lsp] format" }
    idx = idx + 1
  end

  if has_capability(client, "documentRangeFormatting") then
    keymaps[idx] = { "<Leader>f<Leader>", custom.format, "[lsp] format", mode = { "x" } }
    idx = idx + 1
  end

  if has_capability(client, "codeAction") then
    keymaps[idx] = { "<Leader>ac", custom.code_action, "[lsp] code action", mode = { "n", "v" } }
    idx = idx + 1

    keymaps[idx] = {
      "<Leader>ca",
      function()
        custom.code_action(true)
      end,
      "[lsp] code action (by kind)",
      mode = { "n", "v" },
    }
    idx = idx + 1
  end

  if has_capability(client, "rename") then
    keymaps[idx] = { "<Leader>rn", custom.rename, "[lsp] rename" }
    idx = idx + 1
  end

  u.set_keymaps("n", keymaps, opts)
end

local function toggle_inlay_hint_mode(bufnr, mode)
  local prev_mode = vim.b.lsp_inlay_hint_mode
  if not mode then
    mode = prev_mode == "" and "i" or ""
  end
  vim.b.lsp_inlay_hint_mode = mode

  if prev_mode == "i" then
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup.inlay_hints })
  elseif prev_mode == "n" then
    vim.lsp.buf.inlay_hint(bufnr, false)
  end

  if mode == "i" then
    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      group = augroup.inlay_hints,
      callback = function()
        vim.lsp.buf.inlay_hint(bufnr, true)
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      buffer = bufnr,
      group = augroup.inlay_hints,
      callback = function()
        vim.lsp.buf.inlay_hint(bufnr, false)
      end,
    })
  elseif mode == "n" then
    vim.lsp.buf.inlay_hint(bufnr, true)
  end
end

function mod.setup_inlay_hints(client, bufnr)
  if not has_capability(client, "inlayHint") then
    return
  end

  vim.b.lsp_inlay_hint_mode = ""

  vim.api.nvim_buf_create_user_command(bufnr, "ToggleInlayHint", function(info)
    local next_mode = info.bang and (vim.b.lsp_inlay_hint_mode == "n" and "" or "n")
      or vim.b.lsp_inlay_hint_mode == "n" and "i"
      or nil
    toggle_inlay_hint_mode(bufnr, next_mode)
  end, {
    bang = true,
    desc = "[lsp] toggle inlay hint",
  })
end

mod.lua_ls = require("plugins.lsp.utils.lua_ls")

return mod
