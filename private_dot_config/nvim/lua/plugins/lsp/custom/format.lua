local denylist = {
  clangd = true,
  html = true,
  jsonls = true,
  pyright = true,
  ts_ls = true,
  stylelint_lsp = true,
}

local denylist_by_filetype = {
  lua = {
    lua_ls = true,
  },
}

local function get_filter(bufnr)
  return function(client)
    if denylist[client.name] then
      return false
    end

    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr or 0 })
    local denylist_for_filetype = denylist_by_filetype[filetype]
    if not denylist_for_filetype then
      return true
    end

    return not denylist_for_filetype[client.name]
  end
end

---@param options? vim.lsp.buf.format.Opts
local function format(options)
  options = options or {}
  options.bufnr = options.bufnr or vim.api.nvim_get_current_buf()
  options.filter = get_filter(options.bufnr)
  vim.lsp.buf.format(options)
end

return format
