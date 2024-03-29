local mod = {
  format = require("plugins.lsp.custom.format"),
  rename = require("plugins.lsp.custom.rename"),
  code_action = require("plugins.lsp.custom.code_action"),
}

---@param offset_encoding 'utf-8'|'utf-16'|'utf-32'
function mod.document_highlight(offset_encoding)
  local params = vim.lsp.util.make_position_params(0, offset_encoding)
  vim.lsp.buf_request(0, "textDocument/documentHighlight", params, nil)
end

---@param offset_encoding 'utf-8'|'utf-16'|'utf-32'
function mod.hover(offset_encoding)
  local params = vim.lsp.util.make_position_params(0, offset_encoding)
  vim.lsp.buf_request(0, "textDocument/hover", params, nil)
end

return mod
