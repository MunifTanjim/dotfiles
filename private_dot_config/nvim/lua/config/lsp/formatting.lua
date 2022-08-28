local denylist = {
  clangd = true,
  jsonls = true,
  tsserver = true,
  stylelint_lsp = true,
}

local denylist_by_filetype = {
  lua = {
    sumneko_lua = true,
  },
  markdown = {
    html = true,
  },
}

local function get_filter(bufnr)
  return function(client)
    if denylist[client.name] then
      return false
    end

    local filetype = vim.api.nvim_buf_get_option(bufnr or 0, "filetype")
    local denylist_for_filetype = denylist_by_filetype[filetype]
    if not denylist_for_filetype then
      return true
    end

    return not denylist_for_filetype[client.name]
  end
end

local function format(bufnr)
  bufnr = bufnr or 0

  vim.lsp.buf.format({
    filter = get_filter(bufnr),
    bufnr = bufnr,
  })
end

local function range_format(bufnr, start_pos, end_pos)
  bufnr = bufnr or 0

  local clients = vim.lsp.get_active_clients({
    bufnr = bufnr,
  })
  local is_allowed = get_filter(bufnr)
  clients = vim.tbl_filter(function(client)
    return client.supports_method("textDocument/rangeFormatting") and is_allowed(client)
  end, clients)

  if #clients == 0 then
    vim.notify("[LSP] Rrange Format request failed, no matching language servers.")
  end

  if #clients > 1 then
    vim.notify("[LSP] Rrange Format request failed, multiple matching language servers.")
  end

  local timeout_ms = 1000
  for _, client in pairs(clients) do
    local params = vim.lsp.util.make_given_range_params(start_pos, end_pos, bufnr)
    params.options = vim.lsp.util.make_formatting_params().options
    local result, err = client.request_sync("textDocument/rangeFormatting", params, timeout_ms, bufnr)
    if result and result.result then
      vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
    elseif err then
      vim.notify(string.format("[LSP][%s] %s", client.name, err), vim.log.levels.WARN)
    end
  end
end

return {
  format = format,
  range_format = range_format,
}
