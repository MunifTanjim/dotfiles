local api = vim.api
local lsp = vim.lsp

local exrc = require("config.exrc")

local method = {
  APPLY_EDIT = "workspace/applyEdit",
  EXECUTE_COMMAND = "workspace/executeCommand",
  PUBLISH_DIAGNOSTICS = "textDocument/publishDiagnostics",
}

local severities = {
  error = 1,
  warning = 2,
  information = 3,
  hint = 4,
}

local function make_organize_imports_params(bufnr)
  return {
    command = "_typescript.organizeImports",
    arguments = { api.nvim_buf_get_name(bufnr) },
  }
end

local function organize_imports(bufnr, callback)
  bufnr = bufnr or api.nvim_get_current_buf()
  lsp.buf_request(bufnr, method.EXECUTE_COMMAND, make_organize_imports_params(bufnr), callback)
end

local function organize_imports_sync(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  lsp.buf_request_sync(bufnr, method.EXECUTE_COMMAND, make_organize_imports_params(bufnr), 500)
end

local function fix_range(range)
  if range["end"].character == -1 then
    range["end"].character = 0
  end
  if range["end"].line == -1 then
    range["end"].line = 0
  end
  if range.start.character == -1 then
    range.start.character = 0
  end
  if range.start.line == -1 then
    range.start.line = 0
  end
end

local function validate_changes(changes)
  for _, _change in pairs(changes) do
    for _, change in ipairs(_change) do
      if change.range then
        fix_range(change.range)
      end
    end
  end
end

local function make_edit_handler(original_handler)
  return function(...)
    local result_or_method = select(2, ...)
    local is_new = type(result_or_method) == "table"
    local result = is_new and result_or_method or select(3, ...)
    if result.edit and result.edit.changes then
      validate_changes(result.edit.changes)
    end

    return original_handler(...)
  end
end

local function make_diagnostics_handler(original_handler)
  return function(...)
    local config_or_client_id = select(4, ...)
    local is_new = type(config_or_client_id) ~= "number"
    local result = is_new and select(2, ...) or select(3, ...)

    local ignore_diagnostics_by_severity = exrc.lsp.tsserver.ignore_diagnostics_by_severity
    local ignore_diagnostics_by_code = exrc.lsp.tsserver.ignore_diagnostics_by_code

    -- Convert string severities to numbers
    ignore_diagnostics_by_severity = vim.tbl_map(function(severity)
      if type(severity) == "string" then
        return severities[severity]
      end

      return severity
    end, ignore_diagnostics_by_severity)

    if #ignore_diagnostics_by_severity > 0 or #ignore_diagnostics_by_code > 0 then
      local filtered_diagnostics = vim.tbl_filter(function(diagnostic)
        -- Only filter out Typescript LS diagnostics
        if diagnostic.source ~= "typescript" then
          return true
        end

        -- Filter out diagnostics with forbidden severity
        if vim.tbl_contains(ignore_diagnostics_by_severity, diagnostic.severity) then
          return false
        end

        -- Filter out diagnostics with forbidden code
        if vim.tbl_contains(ignore_diagnostics_by_code, diagnostic.code) then
          return false
        end

        return true
      end, result.diagnostics)

      result.diagnostics = filtered_diagnostics
    end

    local config_idx = is_new and 4 or 6
    local config = select(config_idx, ...) or {}

    if is_new then
      original_handler(select(1, ...), select(2, ...), select(3, ...), config)
    else
      original_handler(select(1, ...), select(2, ...), select(3, ...), select(4, ...), select(5, ...), config)
    end
  end
end

local function patch_client(client)
  if client._patched_handlers then
    return
  end

  local edit_handler = client.handlers[method.APPLY_EDIT] or lsp.handlers[method.APPLY_EDIT]
  client.handlers[method.APPLY_EDIT] = make_edit_handler(edit_handler)

  local diagnostics_handler = client.handlers[method.PUBLISH_DIAGNOSTICS] or lsp.handlers[method.PUBLISH_DIAGNOSTICS]
  client.handlers[method.PUBLISH_DIAGNOSTICS] = make_diagnostics_handler(diagnostics_handler)

  client._patched_handlers = true
end

local mod = {
  -- source: https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/4405c1a9/lua/nvim-lsp-ts-utils/organize-imports.lua
  organize_imports = organize_imports,
  organize_imports_sync = organize_imports_sync,

  -- source: https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/1af2922c/lua/nvim-lsp-ts-utils/client.lua
  patch_client = patch_client,
}

return mod
