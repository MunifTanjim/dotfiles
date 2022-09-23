local u = {}

---@param server_name string
---@param settings_patcher fun(settings: table): table
function u.patch_lsp_settings(server_name, settings_patcher)
  local function patch_settings(client)
    client.config.settings = settings_patcher(client.config.settings)
    client.notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end

  local clients = vim.lsp.get_active_clients({ name = server_name })
  if #clients > 0 then
    patch_settings(clients[1])
    return
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == server_name then
        patch_settings(client)
        return true
      end
    end,
  })
end

---@param mode string|string[]
---@param lhs string
---@param rhs string|fun():nil
---@param desc_or_opts string|table
---@param opts? table
function u.set_keymap(mode, lhs, rhs, desc_or_opts, opts)
  if not opts then
    opts = type(desc_or_opts) == "table" and desc_or_opts or { desc = desc_or_opts }
  else
    opts.desc = desc_or_opts
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param default_mode string|string
---@param maps {[1]: string, [2]: string|(fun():nil), [3]?: string, [4]?: table}|table
---@param default_opts? table
function u.set_keymaps(default_mode, maps, default_opts)
  default_opts = default_opts or {}
  for _, map in ipairs(maps) do
    local mode, lhs, rhs, map_opts = map.mode or default_mode, map[1], map[2], map[4] or {}
    map.desc = map.desc or map[3]
    map.mode, map[1], map[2], map[3], map[4] = nil, nil, nil, nil, nil
    local opts = vim.tbl_extend("keep", map, map_opts, default_opts, { silent = true })
    u.set_keymap(mode, lhs, rhs, opts)
  end
end

local has_which_key, which_key = pcall(require, "which-key")
if has_which_key then
  function u.set_keymap(mode, lhs, rhs, desc_or_opts, opts)
    if not opts then
      opts = type(desc_or_opts) == "table" and desc_or_opts or { desc = desc_or_opts }
    else
      opts.desc = desc_or_opts
    end

    local modes = type(mode) == "table" and mode or { mode }
    for _, map_mode in ipairs(modes) do
      which_key.register({ [lhs] = { rhs, opts.desc, mode = map_mode } }, opts)
    end
  end

  function u.set_keymaps(default_mode, maps, fallback_opts)
    fallback_opts = fallback_opts or {}

    local which_key_maps_by_mode = {}

    for _, map in ipairs(maps) do
      local mode, lhs, rhs, desc, map_opts = map.mode or default_mode, map[1], map[2], map[3], map[4] or {}
      map.mode, map[1], map[2], map[3], map[4] = nil, nil, nil, nil, nil

      local modes = type(mode) == "table" and mode or { mode }
      for _, map_mode in ipairs(modes) do
        if not which_key_maps_by_mode[map_mode] then
          which_key_maps_by_mode[map_mode] = {}
        end

        which_key_maps_by_mode[map_mode][lhs] = vim.tbl_extend("keep", { rhs, desc }, map, map_opts)
      end
    end

    for mode, which_key_maps in pairs(which_key_maps_by_mode) do
      which_key.register(which_key_maps, vim.tbl_extend("keep", { mode = mode }, fallback_opts))
    end
  end
end

return u
