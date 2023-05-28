local plugin = {
  "folke/which-key.nvim",
}

local which_key

local function set_keymap(mode, lhs, rhs, desc_or_opts, opts)
  if opts then
    opts.desc = desc_or_opts
  else
    opts = type(desc_or_opts) == "table" and desc_or_opts or { desc = desc_or_opts }
  end

  local modes = type(mode) == "table" and mode or { mode }
  for _, map_mode in ipairs(modes) do
    which_key.register({ [lhs] = { rhs, opts.desc, mode = map_mode } }, opts)
  end
end

local function set_keymaps(default_mode, maps, fallback_opts)
  fallback_opts = fallback_opts or {}

  local which_key_maps_by_mode = {}

  for _, map in ipairs(maps) do
    local mode, lhs, rhs, desc, opts = map.mode or default_mode, map[1], map[2], map[3], map[4]
    if opts then
      opts.desc = desc
    else
      opts = type(desc) == "table" and desc or { desc = desc }
    end
    map.mode, map[1], map[2], map[3], map[4] = nil, nil, nil, nil, nil

    local modes = type(mode) == "table" and mode or { mode }
    for _, map_mode in ipairs(modes) do
      if not which_key_maps_by_mode[map_mode] then
        which_key_maps_by_mode[map_mode] = {}
      end

      which_key_maps_by_mode[map_mode][lhs] = vim.tbl_extend("keep", { rhs, map.desc or opts.desc }, map, opts)
    end
  end

  for mode, which_key_maps in pairs(which_key_maps_by_mode) do
    local opts = vim.tbl_extend("keep", { mode = mode }, fallback_opts)
    if opts.expr then
      opts.replace_keycodes = true
    end

    which_key.register(which_key_maps, opts)
  end
end

function plugin.config()
  local u = require("config.utils")

  which_key = require("which-key")

  local presets = require("which-key.plugins.presets")
  presets.operators["v"] = nil
  presets.operators["c"] = nil
  presets.operators["d"] = nil
  presets.operators["y"] = nil

  which_key.setup({
    window = {
      border = "single",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 0, 0, 0, 0 },
    },
  })

  which_key.register({
    d = { name = "DAP" },
    f = { name = "Telescope" },
    o = { name = "Open" },
  }, { prefix = "<Leader>" })

  u.set_keymap = set_keymap
  u.set_keymaps = set_keymaps

  vim.schedule(function()
    vim.api.nvim_set_hl(0, "WhichKeyFloat", { link = "Normal" })
  end)
end

return plugin
